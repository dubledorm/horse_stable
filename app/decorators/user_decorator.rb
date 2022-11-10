class UserDecorator < Draper::Decorator
  delegate_all

  def nick_name
    return object.nick_name unless object.nick_name.nil?

    I18n.t('not_defined_yet')
  end

  def main_image_cover
    image_wrapper(object.main_image, [1200, 1200])
  end
end