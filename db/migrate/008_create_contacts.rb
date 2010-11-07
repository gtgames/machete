#sequel -d postgres://host/database > db/migrations/001_start.rb
class CreateContacts < Sequel::Migration
  def up
    create_table(:contacts) do
      primary_key :id
      String  :author,    :size =>255
      String  :email,     :size =>255
      String  :text,      :text => true
      String  :address,   :size =>255
      String  :telephon,  :size =>255


      Float   :spaminess
      String  :signature, :size => 22
      String  :classification
      String  :status
      String  :ip

      DateTime :created_at
    end
  end

  def down
    drop_table(:contacts)
  end
end