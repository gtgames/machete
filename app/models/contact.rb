class Contact < Sequel::Model
  plugin :validation_helpers
  def validate
    super
    validates_presence [:author, :email]
  end
  def before_save
    data = {
      :content        => "#{self.author}\n\n#{self.text}",
      :type           => "comment",
      :platform       => "small-machete",
      :"author-name"  => self.author,
      :"author-email" => self.email,
      :"author-ip"    => self.ip,
      :message        => self.text
    }
    status, result = DFS.post_document(data)
    if status == 200
      self.signature      = result["signature"]
      self.spaminess      = result["spaminess"]
      self.classification = result["classification"]
    end
    self.created_at = Time.now
  end
end