require "application_system_test_case"

class BankAccountsTest < ApplicationSystemTestCase
  test "Creating a new bank account" do
    visit bank_accounts_path
    assert_selector "h1", text: "Банковские счета"

    click_on "Добавить"
    fill_in "Наименование", with: "Новый банковский счет"
    click_on "Create Bank account"

    assert_selector "h1", text: "Банковские счета"
    assert_text "Новый банковский счет"
  end

  test "Updating a bank account" do
    visit bank_accounts_path
    assert_selector "h1", text: "Банковские счета"

    click_on "Изменить", match: :first
    fill_in "Наименование", with: "Основной банковский счет"
    click_on "Update Bank account"

    assert_selector "h1", text: "Банковские счета"
    assert_text "Основной банковский счет"
  end

  test "Destroing a bank account" do
    visit bank_accounts_path
    assert_text bank_accounts(:first).name
    click_on "Удалить"
    assert_no_text bank_accounts(:first).name
  end
end
