module Analytical
  module Modules
    class Google
      include Analytical::Modules::Base

      def initialize(options={})
        super
        @tracking_command_location = :head_append
      end

      def init_javascript(location)
        init_location(location) do
          js = <<-HTML
          <!-- Analytical Init: Google -->
          <script type="text/javascript">
            var _gaq = _gaq || [];
            _gaq.push(['_setAccount', '#{options[:key]}']);
            _gaq.push(['_setDomainName', '#{options[:domain]}']);
            #{"_gaq.push(['_setAllowLinker', true]);" if options[:allow_linker]}
            _gaq.push(['_trackPageview']);
            (function() {
              var ga = document.createElement('script'); ga.type = 'text/javascript'; ga.async = true;
              ga.src = ('https:' == document.location.protocol ? 'https://ssl' : 'http://www') + '.google-analytics.com/ga.js';
              var s = document.getElementsByTagName('script')[0]; s.parentNode.insertBefore(ga, s);
            })();
          </script>
          HTML
          js
        end
      end

      def track(*args)
        "_gaq.push(['_trackPageview'#{args.empty? ? ']' : ', "' + args.first + '"]'});"
      end
      
      def event(name, *args)
        data = args.first || nil
        data_string = data ? ", '#{data.to_json}'" : ""
        "_gaq.push(['_trackEvent', \"Event\", \"#{name}\"" + data_string + "]);"
      end
      
      def custom_event(category, action, opt_label=nil, opt_value=nil)
        args = [category, action, opt_label, opt_value].compact
        "_gaq.push(" + [ "_trackEvent", *args].to_json + ");"
      end

    end
  end
end