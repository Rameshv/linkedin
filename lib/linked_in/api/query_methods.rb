module LinkedIn
  module Api

    module QueryMethods

      def profile(options={})
        path = person_path(options)
        simple_query(path, options)
      end

      def connections(options={})
        path = "#{person_path(options)}/connections"
        simple_query(path, options)
      end

      def network_updates(options={})
        path = "#{person_path(options)}/network/updates"
        network_query(path, options)
        #simple_query(path, options)
      end

      def company(options = {})
        path = company_path(options)
        simple_query(path, options)
      end

      private

      def simple_query(path, options={})
        fields = options[:fields] || LinkedIn.default_profile_fields

        if options[:public]
          path +=":public"
        elsif fields
          path +=":(#{fields.map { |f| f.to_s.gsub("_", "-") }.join(',')})"
        end

        Mash.from_json(get(path))
      end

      def network_query(path, options)

        fields = options[:fields] || LinkedIn.default_profile_fields

        if options[:public]
          path +=":public"
        elsif fields
          path +=":(#{fields.map { |f| f.to_s.gsub("_", "-") }.join(',')})"
        end

        query_str = ''
        options[:filters].each do |key, val|
          query_str += ((query_str=='') ? '' : '&') + key.to_s + '=' + val.to_s
        end
        path += '?' + query_str unless query_str == ''
        #puts path
        Mash.from_json(get(path))
      end

      def person_path(options)
        path = "/people/"
        if options[:id]
          path += "id=#{options[:id]}"
        elsif options[:url]
          path += "url=#{CGI.escape(options[:url])}"
        else
          path += "~"
        end
      end

      def company_path(options)
        path = "/companies/"
        if options[:id]
          path += "id=#{options[:id]}"
        elsif options[:url]
          path += "url=#{CGI.escape(options[:url])}"
        elsif options[:name]
          path += "universal-name=#{CGI.escape(options[:name])}"
        elsif options[:domain]
          path += "email-domain=#{CGI.escape(options[:domain])}"
        else
          path += "~"
        end
      end

    end

  end
end