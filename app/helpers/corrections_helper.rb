Alfred::App.helpers do
  def correction_status_label(status)
  	I18n.translate("assignments.status.#{status.to_sym}")
  end
end
