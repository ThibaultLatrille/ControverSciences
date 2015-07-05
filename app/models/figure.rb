class Figure < ActiveRecord::Base
  belongs_to :reference
  belongs_to :timeline
  belongs_to :user
  validate  :picture_size

  mount_uploader :picture, PictureUploader

  def set_file_name
    if self.reference_id
      self.file_name = "#{self.user_id}_ref_#{self.reference_id}_v_#{
        Figure.where( user_id: self.user_id, reference_id: self.reference_id).count }"
    elsif self.timeline_id
      self.file_name = "#{self.user_id}_tim_#{self.timeline_id}_v_#{
        Figure.where( user_id: self.user_id, reference_id: self.reference_id).count }"
    elsif self.frame_timeline_id
      self.file_name = "#{self.user_id}_fra_#{self.frame_timeline_id}_v_#{
      Figure.where( user_id: self.user_id, frame_timeline_id: self.frame_timeline_id).count }"
    else
      self.file_name = "#{self.user_id}_profil_v_#{
        Figure.where( user_id: self.user_id, profil: true ).count }"
    end
  end

  def user_name
    User.select( :email ).find(self.user_id).email.partition("@")[0].gsub(".", "_" )
  end

  private

  # Validates the size of an uploaded picture.
  def picture_size
    if picture.size > 5.megabytes
      errors.add(:picture, 'Taille de la figure supérieure à 5 Mo, veuillez réduire la taille de celle-ci.')
    end
    if picture.size > 5.megabytes
      errors.add(:picture, 'Taille de la figure supérieure à 5 Mo, veuillez réduire la taille de celle-ci.')
    end
  end
end
