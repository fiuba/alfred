class Solution
  def as_csv(sep = ";")
    info_about_me.concat( info_about_correction ).join(sep)
  end

  private
    def has_correction?
      not self.correction.nil?
    end

    def has_grade?
      has_correction? and not self.correction.grade.nil?
    end

    def info_about_me
      [ self.account.courses.first.name,                          # Course name
        self.account.tag,                                         # Student shift
        self.account.buid,                                        
        self.account.prety_full_name,                             # Student name
        self.created_at.strftime(I18n.t('date.formats.default')), # Submition date
        self.assignment.name                                      # Assignment date
      ]
    end

    def info_about_correction
      [ (has_correction?) ? 
          self.correction.created_at.strftime(I18n.t('date.formats.default')) : 'not_assigned_yet',
        (has_grade?) ?
          self.correction.grade.to_s : 'not_graded_yet',
        (has_correction?) ?
          self.correction.teacher.prety_full_name : 'not_assigned_yet' 
      ]
    end

end
