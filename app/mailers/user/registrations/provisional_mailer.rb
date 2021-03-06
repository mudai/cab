class User::Registrations::ProvisionalMailer < Jpmobile::Mailer::Base
  default from: 'noreply@qupio.jp'

  # テンプレートが無かった場合に利用されるデフォルトの件名
  def default_subject
    "[<%= attributes[:nickname] %>様] 仮登録が完了しました" # yaml化？ TODO
  end

  def provisional_mail(attributes)
    @attributes = attributes # デフォルトのerbテンプレート用
    # templateが無い場合のデフォルトの文章はuser/registrations/provisional_mailer.text.erbが利用される

    org = Organization.find_by(host: attributes[:host])
    self.class.default_url_options[:host] = org.host
    if org && template = org.mail_templates.find_by(code: "provisional_mail")
      mail(
        to: attributes[:email],
        subject: ERB.new(template.subject).result(binding),
        body: ERB.new(template.body).result(binding)
      )
    else
      mail to: attributes[:email], subject: ERB.new(default_subject).result(binding)
    end
  end

end
