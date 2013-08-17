Alfred::App.controllers :reporters do

  get :gradings, :map => '/assignments/:assignment_id/gradings_report' do
    halt 404 if params[:assignment_id].nil?

    assignment = Assignment.get( params[:assignment_id].to_i )
    halt 404 if assignment.nil?

    stream = GradingReport.report( assignment )

    file_name = GradingReport.file_name(assignment)
    response.headers['Content-Disposition'] = "attachment; filename=#{file_name}"
    response.headers['Content-Type'] = 'text/csv'

    stream
  end

end
