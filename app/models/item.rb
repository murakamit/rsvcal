# -*- coding: utf-8 -*-

class Item < ActiveRecord::Base
  belongs_to :group
  has_many :weeklies

  include Nameable
  include Memoable
  include Removable
  require 'RMagick'

  before_validation :replace_nil_to_empty_at_photo
  validates :group_id, presence: true
  validate :validate_presence_group
  validate :validate_photo

  IMAGES_PATH = Rails.public_path.join "images"
  PHOTO_DIR = "items"
  PHOTO_PATH = IMAGES_PATH.join PHOTO_DIR
  REX_PHOTONAME = /\Aitem(\d+)-(\d+)/

  # --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
  private
  def validate_presence_group
    k = :group_id
    errors.add k, "No such group" if Group.where(id: self[k]).empty?
  end

  def replace_nil_to_empty_at_photo
    self.photo = '' if self.photo.nil?
  end

  REX_EXT = /\A.+\.([a-zA-Z]+)\Z/

  def next_photo_name(id, ext)
    n = 1
    Dir.foreach(PHOTO_PATH) { |s|
      m = REX_PHOTONAME.match s
      next unless m
      next if m[1].to_i != id.to_i
      x = m[2].to_i + 1
      n = x if n < x
    }
    PHOTO_DIR + "/item#{id}-#{n}.#{ext}".downcase
  end

  def validate_photo
    if self.photo.present? && (! File.size? self.photo)
      errors.add :photo, "missing on server storage"
    end
  end

  # --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
  public
  def save_photo(upfile) # params[:item][:photo]
    begin
      Dir.mkdir PHOTO_PATH
    rescue Errno::EEXIST
      # nop
    rescue
      return nil
    end
    m = REX_EXT.match upfile.original_filename
    return nil unless m
    img = Magick::Image.from_blob upfile.read
    return nil if img.empty?
    img = img.first
    img.resize_to_fit! 160,160
    fname = next_photo_name(self.id, m[1])
    img.write(IMAGES_PATH.join(fname)) ? fname : nil
  end
end
