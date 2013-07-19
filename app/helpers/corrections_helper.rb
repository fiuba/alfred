Alfred::App.helpers do
	LABELS_FOR_STATUS = { 
		:solution_pending => I18n.translate('assignments.status.solution_pending'),
		:correction_pending => I18n.translate('assignments.status.correction_pending'),
		:correction_in_progress => I18n.translate('assignments.status.correction_in_progress'),
		:correction_passed => I18n.translate('assignments.status.correction_passed'),
		:correction_failed => I18n.translate('assignments.status.correction_failed')
	}

  def correction_status_label(status)
  	LABELS_FOR_STATUS[status.to_sym]
  end
end
