class User::Registrations::DefinitiveMailer < Jpmobile::Mailer::Base
  default from: 'noreply@qupio.jp'

  # テンプレートが無かった場合に利用されるデフォルトの件名
  def default_subject
    "[<%= attributes[:nickname] %>様] 本登録が完了しました" # yaml化？ TODO
  end

  def definitive_mail(attributes)
    @attributes = attributes # デフォルトのerbテンプレート用
    # templateが無い場合のデフォルトの文章はuser/registrations/definitive_mailer.text.erbが利用される

    if template = MailTemplate.find_by(code: "definitive_mail")
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
