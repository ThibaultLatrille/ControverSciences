class Figure < ApplicationRecord
  include CarrierWave::MiniMagick
  belongs_to :reference
  belongs_to :timeline
  belongs_to :user
  belongs_to :partner

  validate :picture_size

  attr_accessor :width, :height, :file_size, :is_image

  mount_uploader :picture, PictureUploader

  def set_file_name
    if self.reference_id
      self.file_name = "#{self.user_id}_ref_#{self.reference_id}_v_#{
      Figure.where(user_id: self.user_id, reference_id: self.reference_id).count }"
    elsif self.timeline_id
      self.file_name = "#{self.user_id}_tim_#{self.timeline_id}_v_#{
      Figure.where(user_id: self.user_id, reference_id: self.reference_id).count }"
    elsif self.img_timeline_id
      self.file_name = "#{self.user_id}_img_#{self.img_timeline_id}_v_#{
      Figure.where(user_id: self.user_id, img_timeline_id: self.img_timeline_id).count }"
    elsif self.partner_id
      self.file_name = "#{self.user_id}_partner_#{self.partner_id}_v_#{
      Figure.where(user_id: self.user_id, partner_id: self.partner_id).count }"
    else
      self.file_name = "#{self.user_id}_profil_v_#{
      Figure.where(user_id: self.user_id, profil: true).count }"
    end
  end

  def user_name
    self.user_id.to_s
  end

  private

  # Validates the size of an uploaded picture.
  def picture_size
    unless file_size
      errors.add(:picture, 'Fichier non reconnu')
    end
    if file_size && file_size > 5.megabytes
      errors.add(:picture, 'Taille de la figure supérieure à 5 Mo.')
    end
    if is_image
      if self.img_timeline_id
        unless width > 1280 && height > 1280
          errors.add :picture, 'Doit faire au moins 1280px*1280px'
        end
      elsif self.reference_id || self.timeline_id
        unless width > 640 && height > 640
          errors.add :picture, 'Doit faire au moins 640px*640px'
        end
      else
        unless width > 250 && height > 250
          errors.add :picture, 'Doit faire au moins 250px*250px'
        end
      end
    end
  end
end
