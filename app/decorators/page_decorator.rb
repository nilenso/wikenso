class PageDecorator < Draper::Decorator
  delegate_all
  include PageSanitizable
end
