class CreateAccounts < Sequel::Migration
  def up
    create_table :accounts do
      primary_key :id
      String :name, :size=>255
      String :surname, :size=>255
      String :email, :size=>255
      String :crypted_password, :size=>255
      String :salt, :size=>255
      String :role, :size=>255
    end
  end

  def down
    drop_table :accounts
  end
end
