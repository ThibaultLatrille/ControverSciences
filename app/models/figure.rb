class Figure < ActiveRecord::Base
  include CarrierWave::MiniMagick
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
    elsif self.img_timeline_id
      self.file_name = "#{self.user_id}_img_#{self.img_timeline_id}_v_#{
      Figure.where( user_id: self.user_id, img_timeline_id: self.img_timeline_id).count }"
    else
      self.file_name = "#{self.user_id}_profil_v_#{
        Figure.where( user_id: self.user_id, profil: true ).count }"
    end
  end

  def user_name
    self.user_id.to_s
  end

  private

  # Validates the size of an uploaded picture.
  def picture_size
    if picture.size > 5.megabytes
      errors.add(:picture, 'Taille de la figure supérieure à 5 Mo.')
    end
    unless picture.file.extension == 'svg'
      image = MiniMagick::Image.open(picture.path)
      if self.img_timeline_id
        unless image[:width] > 1280 && image[:height] > 1280
          errors.add :picture, 'Doit faire au moins 1280px*1280px'
        end
      elsif self.reference_id ||self.timeline_id
        unless image[:width] > 640 && image[:height] > 640
          errors.add :picture, 'Doit faire au moins 640px*640px'
        end
      else
        unless image[:width] > 250 && image[:height] > 250
          errors.add :picture, 'Doit faire au moins 250px*250px'
        end
      end
    end
  end
end
