require "application_system_test_case"

class Admin::DriversTest < ApplicationSystemTestCase
  setup do
    @viewer_email = random_email
    @editor_email = random_email
    @administrator_email = random_email
  end

  test "as a Viewer, get index, edit, and create users" do
    system_test_signin(:viewer)
    click_on 'settings-link'
    click_on 'Users'

    assert_selector 'h1', text: 'Users'

    # create a viewer
    within "#new_user" do 
      fill_in 'Email', with: @viewer_email
      fill_in 'Password', with: 'password123'
      select 'Viewer', from: 'user-role-dropdown'
      click_button 'Create'
    end

    user = User.last

    within "#flash" do 
      assert_text "User was successfully created."
    end

    within ".table-users" do 
      assert_selector "tr", count: 2
      assert_selector "td .email", text: @viewer_email
    end

    click_on "user-#{user.id}-edit-icon"
    assert_selector "h1", text: "Editing User"
    select 'Editor',from: 'user-role-dropdown'
    click_button "Save"

    within "#flash" do 
      assert_text "Not authorized. You can edit users with the same role as your Viewer role or less."
    end    

    click_on "user-#{user.id}-edit-icon"
    assert_selector "h1", text: "Editing User"
    fill_in 'Email', with: 'new_email@example.com'
    click_button "Save"

    within "#flash" do 
      assert_text "User was successfully updated."
    end    

    within ".table-users" do 
      assert_selector "td .email", text: 'new_email@example.com'
    end

    # try to create editor but fail
    within "#new_user" do 
      fill_in 'Email', with: @editor_email
      fill_in 'Password', with: 'password123'
      select 'Editor',from: 'user-role-dropdown'
      click_button 'Create'
    end

    within ".table-users" do 
      assert_selector "tr", count: 2
    end

    within "#flash" do 
      assert_text "Not authorized. You can create users with the same role as your Viewer role or less."
    end

    user = User.last

    click_on "user-#{user.id}-delete-icon"

    within "#flash" do 
      assert_text "User was successfully destroyed."
    end

    within ".table-users" do 
      assert_selector "tr", count: 1
      assert_no_selector "td .email", text: @editor_email
    end
  end

  test "as an Editor, get index, and create users" do
    system_test_signin(:editor)
    click_on 'settings-link'
    click_on 'Users'

    assert_selector 'h1', text: 'Users'

    # create a viewer
    within "#new_user" do 
      fill_in 'Email', with: @viewer_email
      fill_in 'Password', with: 'password123'
      select 'Viewer', from: 'user-role-dropdown'
      click_button 'Create'
    end

    within "#flash" do 
      assert_text "User was successfully created."
    end

    within ".table-users" do 
      assert_selector "tr", count: 2
      assert_selector "td .email", text: @viewer_email
    end

    # create an editor
    within "#new_user" do 
      fill_in 'Email', with: @editor_email
      fill_in 'Password', with: 'password123'
      select 'Editor',from: 'user-role-dropdown'
      click_button 'Create'
    end

    within ".table-users" do 
      assert_selector "tr", count: 3
      assert_selector "td .email", text: @editor_email
    end

    # try to create and administrator but fail
    within "#new_user" do 
      fill_in 'Email', with: @editor_email
      fill_in 'Password', with: 'password123'
      select 'Administrator',from: 'user-role-dropdown'
      click_button 'Create'
    end
    within "#flash" do 
      assert_text "Not authorized. You can create users with the same role as your Editor role or less."
    end

    user = User.last

    click_on "user-#{user.id}-delete-icon"

    within "#flash" do 
      assert_text "User was successfully destroyed."
    end

    within ".table-users" do 
      assert_selector "tr", count: 2
      assert_no_selector "td .email", text: user.email
    end
  end

  test "as an Adminstrator, get index, create, destroy users" do
    system_test_signin(:administrator)
    click_on 'settings-link'
    click_on 'Users'

    assert_selector 'h1', text: 'Users'

    # create a viewer
    within "#new_user" do 
      fill_in 'Email', with: @viewer_email
      fill_in 'Password', with: 'password123'
      select 'Viewer', from: 'user-role-dropdown'
      click_button 'Create'
    end

    within "#flash" do 
      assert_text "User was successfully created."
    end

    within ".table-users" do 
      assert_selector "tr", count: 2
      assert_selector "td .email", text: @viewer_email
    end

    # create an editor
    within "#new_user" do 
      fill_in 'Email', with: @editor_email
      fill_in 'Password', with: 'password123'
      select 'Editor',from: 'user-role-dropdown'
      click_button 'Create'
    end

    within ".table-users" do 
      assert_selector "tr", count: 3
      assert_selector "td .email", text: @editor_email
    end

    # create an administrator
    within "#new_user" do 
      fill_in 'Email', with: @administrator_email
      fill_in 'Password', with: 'password123'
      select 'Administrator',from: 'user-role-dropdown'
      click_button 'Create'
    end
    within ".table-users" do 
      assert_selector "tr", count: 4
      assert_selector "td .email", text: @administrator_email
    end

    user = User.last

    click_on "user-#{user.id}-delete-icon"

    within "#flash" do 
      assert_text "User was successfully destroyed."
    end

    within ".table-users" do 
      assert_selector "tr", count: 3
      assert_no_selector "td .email", text: user.email
    end

    user = User.last

    click_on "user-#{user.id}-edit-icon"
    assert_selector "h1", text: "Editing User"
    select 'Administrator',from: 'user-role-dropdown'
    click_button "Save"

    within "#flash" do 
      assert_text "User was successfully updated."
    end

    within ".table-users" do 
      assert_selector "tr", count: 3
      assert_selector "td .role", text: 'Administrator', count: 2
    end
  
    click_on "user-#{user.id}-delete-icon"

    within "#flash" do 
      assert_text "User was successfully destroyed."
    end

    within ".table-users" do 
      assert_selector "tr", count: 2
    end

    # try deleting themselves
    user = User.first
    assert_no_selector "user-#{user.id}-delete-icon"
  end
end