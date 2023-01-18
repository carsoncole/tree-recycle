require "test_helper"

class Admin::OperationsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @viewer = create(:viewer)
    @editor = create(:editor)
    @administrator = create(:administrator)
  end

  test "should get index as" do
    get admin_operations_url(as: @viewer)
    assert_response :success

    get admin_operations_url(as: @administrator)
    assert_response :success

    get admin_operations_url(as: @editor)
    assert_response :success
  end

  test "archiving all reservations as administrator" do
    create_list(:reservation_with_coordinates, 10, status: :picked_up, is_routed: false)

    assert_difference('Reservation.archived.count', 10) do
      delete admin_post_event_archive_reservations_path(as: @administrator)
    end
  end

  test "not archiving all reservations as viewer" do
    create_list(:reservation_with_coordinates, 10, status: :picked_up, is_routed: false)
    assert_difference('Reservation.archived.count', 0) do
      delete admin_post_event_archive_reservations_path(as: @viewer)
    end
    assert_response :unauthorized
  end


  test "not archiving all reservations as editor" do
    create_list(:reservation_with_coordinates, 10, status: :picked_up, is_routed: false)
    assert_difference('Reservation.archived.count', 0) do
      delete admin_post_event_archive_reservations_path(as: @editor)
    end
    assert_response :unauthorized
  end



  test "merging unarchived and archived" do
    # archived = 5
    archived = create_list(:reservation_with_coordinates, 5, status: 'archived', is_routed: false, no_emails: true )

    # unarchived = 10
    create_list(:reservation_with_coordinates, 10, status: :picked_up, is_routed: false, no_emails: true)

    # unarchived with same as existing archived emails = 5
    archived[0..4].each do |r|
      create(:reservation_with_coordinates, email: r.email, status: :picked_up, is_routed: false, no_emails: true)
    end

    create_list(:reservation_with_coordinates, 3, status: 'unconfirmed', is_routed: false, no_emails: true)
    assert_equal 5, Reservation.archived.count

    assert_difference('Reservation.archived.count', 10) do
      delete admin_post_event_archive_reservations_path(as: @administrator)
    end

    assert_equal 0, Reservation.unconfirmed.count
    assert_equal 0, Reservation.not_archived.not_unconfirmed.count
    assert_equal 15, Reservation.archived.count
  end

  test "destroying unconfirmed" do
    create_list(:reservation_with_coordinates, 6, status: 'unconfirmed', no_emails: true, is_routed: false)

    assert_difference('Reservation.unconfirmed.count', -6) do
      delete admin_destroy_unconfirmed_reservations_path(as: @administrator)
    end
  end

  test "not destroying unconfirmed as viewer or editor" do
    create_list(:reservation_with_coordinates, 6, status: 'unconfirmed', no_emails: true, is_routed: false)

    assert_difference('Reservation.unconfirmed.count', 0) do
      delete admin_destroy_unconfirmed_reservations_path(as: @viewer)
    end
    assert_response :unauthorized

    assert_difference('Reservation.unconfirmed.count', 0) do
      delete admin_destroy_unconfirmed_reservations_path(as: @editor)
    end
    assert_response :unauthorized
  end

  test "destroying archived" do
    archived = create_list(:reservation_with_coordinates, 5, status: 'archived', is_routed: false, no_emails: true )

    assert_difference('Reservation.archived.count', -5) do
      delete admin_destroy_all_archived_reservations_path(as: @administrator)
    end
  end

  test "not destroying archived as viewer or editor" do
    archived = create_list(:reservation_with_coordinates, 5, status: 'archived', is_routed: false, no_emails: true )

    assert_difference('Reservation.archived.count', 0) do
      delete admin_destroy_all_archived_reservations_path(as: @viewer)
    end
    assert_response :unauthorized

    assert_difference('Reservation.archived.count', 0) do
      delete admin_destroy_all_archived_reservations_path(as: @editor)
    end
    assert_response :unauthorized
  end

  test "destroying all reservations" do
    create_list(:reservation_with_coordinates, 5, is_routed: false, status: :pending_pickup)
    create_list(:reservation_with_coordinates, 5, is_routed: false, status: :unconfirmed)
    create_list(:reservation_with_coordinates, 5, is_routed: false, status: :archived)
    assert_difference('Reservation.count', -15) do
      delete admin_destroy_all_reservations_path(as: @administrator)
    end
  end

  test "not destroying all reservations as editor or viewer" do
    create_list(:reservation_with_coordinates, 5, is_routed: false)
    assert_difference('Reservation.count', 0) do
      delete admin_destroy_all_reservations_path(as: @editor)
    end
    assert_response :unauthorized

    assert_difference('Reservation.count', 0) do
      delete admin_destroy_all_reservations_path(as: @viewer)
    end
    assert_response :unauthorized
  end
end
