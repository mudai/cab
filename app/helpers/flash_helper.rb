module FlashHelper
  ALERT_TYPES = [:error, :info, :success, :warning]

  def display_flash
    flash_messages = []
    flash.each do |type, message|
      next if message.blank?
    
      type = :success if type == :notice
      type = :error   if type == :alert
      next unless ALERT_TYPES.include?(type)

# TODO: この辺のhtmlタグはデザインによって変更する
      Array(message).each do |msg|
        text = content_tag(:div,
                           content_tag(:button, raw("&times;"), :class => "close", "data-dismiss" => "alert") +
                           msg.html_safe, :class => "alert fade in alert-#{type}")
        flash_messages << text if message
      end 
    end 
    flash_messages.join("\n").html_safe
  end 
end
