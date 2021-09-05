module ActsHelper
  def detect_doc_operation(id)
    status = @vchasno_client.doc(@doc_id)['status']
    if status == 7008
      return 'view_session'
    else
      return 'sign_session'
    end
  end
end
