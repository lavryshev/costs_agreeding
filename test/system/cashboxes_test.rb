require "application_system_test_case"

class CashboxesTest < ApplicationSystemTestCase
  test "Creating a new cashbox" do
    current_user = users(:user1)
    as_user current_user do
      visit cashboxes_path
      assert_selector "h1", text: "Кассы"

      click_on "Добавить"
      fill_in "Наименование", with: "Новая касса"
      click_on "Create Cashbox"

      assert_selector "h1", text: "Кассы"
      assert_text "Новая касса"
    end
  end

  test "Updating a cashbox" do
    current_user = users(:user1)
    as_user current_user do
      visit cashboxes_path
      assert_selector "h1", text: "Кассы"

      click_on "Изменить", match: :first
      fill_in "Наименование", with: "Касса usd"
      click_on "Update Cashbox"

      assert_selector "h1", text: "Кассы"
      assert_text "Касса usd"
    end
  end

  test "Destroing a bank account" do
    current_user = users(:user1)
    as_user current_user do
      visit cashboxes_path
      assert_text cashboxes(:first).name
      click_on "Удалить"
      assert_no_text cashboxes(:first).name
    end
  end
end
