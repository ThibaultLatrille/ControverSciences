class UserDetail < ActiveRecord::Base
  belongs_to :user
  mount_uploader :picture, PictureUploader
  validate  :picture_size

  def file_name
    User.find(self.user_id).email.partition("@")[0].gsub(".", "_" )
  end

  private

  # Validates the size of an uploaded picture.
  def picture_size
    if picture.size > 5.megabytes
      errors.add(:picture, "La taille de l'image doit être inférieur à 5 Mo")
    end
  end

end
