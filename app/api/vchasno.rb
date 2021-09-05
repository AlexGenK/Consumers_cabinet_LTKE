module Vchasno
    module V2
        class Client
            API_ENDPOINT = 'https://vchasno.ua/api/v2'.freeze
            DOCUMENT_STATUS = {7000 => 'завантажений у систему', 
                               7001 => 'готовий для підпису і надсилання',
                               7002 => 'надісланий контрагенту на перший підпис', 
                               7003 => 'підписаний одним чи кількома підписами',
                               7004 => 'підписаний власником, та очікує на підпис контрагента', 
                               7006 => 'відхилений контрагентом',
                               7007 => 'підписаний одним чи кількома підписами',
                               7008 => 'накладено всі очікувані підписи',
                               7010 => 'надісланий підписантам'}

            attr_reader :token

            def initialize(token = nil)
                @token = token
            end

            def out_docs(edrpou = nil)
                params_h = edrpou == nil ? {} : {recipient_edrpou: edrpou}
                request(htt_method: :get, endpoint: 'documents', params: params_h)
            end

            def sign_doc(id, code, mail)
                body_h = { document_id: id,
                          email: mail,
                          edrpou: code,
                          type: "sign_session",
                          on_cancel_url: "https://landing.vchasno.com.ua/on_cancel_url",
                          on_finish_url: "https://landing.vchasno.com.ua/on_finish_url" }.to_json
                request(htt_method: :post, endpoint: 'sign-sessions', params: body_h)
            end

            private

            def client
                @_client = Faraday.new(API_ENDPOINT) do |client|
                    client.response :logger, nil, { headers: true, bodies: true }
                    client.request :url_encoded
                    client.adapter Faraday.default_adapter
                    client.headers['Authorization'] = token if token.present?
                    client.headers['Content-Type'] = "application/json"
                end
            end

            def request(htt_method:, endpoint:, params: {})
                response = client.public_send(htt_method, endpoint, params)
                Oj.load(response.body)
            end
        end
    end
end
