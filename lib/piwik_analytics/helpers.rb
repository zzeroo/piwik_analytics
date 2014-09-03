module PiwikAnalytics
  module Helpers
    def piwik_tracking_tag
      config = PiwikAnalytics.configuration
      return if config.disabled?

      if config.trackingTimer
        if config.use_async?
          trackingTimer = <<-CODE
          _paq.push(['setLinkTrackingTimer', #{config.trackingTimer}]); // #{config.trackingTimer} milliseconds
          CODE
        else
          trackingTimer = <<-CODE
          piwikTracker.setLinkTrackingTimer( #{config.trackingTimer} ); // #{config.trackingTimer} milliseconds
          CODE
        end
      end

      if config.use_async?
        tag = <<-CODE
        <!-- Piwik -->
        <script type="text/javascript">
          var _paq = _paq || [];
            #{trackingTimer}
          _paq.push(['trackPageView']);
          _paq.push(['enableLinkTracking']);
          (function() {
            var u=(("https:" == document.location.protocol) ? "https" : "http") + "://#{config.url}/";
            _paq.push(['setTrackerUrl', u+'piwik.php']);
            _paq.push(['setSiteId', #{config.id_site}]);
            var d=document, g=d.createElement('script'), s=d.getElementsByTagName('script')[0]; g.type='text/javascript';
            g.defer=true; g.async=true; g.src=u+'piwik.js'; s.parentNode.insertBefore(g,s);
          })();
        </script>
        <noscript><p><img src="http://#{config.url}/piwik.php?idsite=#{config.id_site}" style="border:0;" alt="" /></p></noscript>
        <!-- End Piwik Code -->
        CODE
        tag.html_safe
      else
        tag = <<-CODE
        <!-- Piwik -->
        <script type="text/javascript">
        var pkBaseURL = (("https:" == document.location.protocol) ? "https://#{config.url}/" : "http://#{config.url}/");
        document.write(unescape("%3Cscript src='" + pkBaseURL + "piwik.js' type='text/javascript'%3E%3C/script%3E"));
        </script><script type="text/javascript">
        try {
                var piwikTracker = Piwik.getTracker(pkBaseURL + "piwik.php", #{config.id_site});
                #{trackingTimer}
                piwikTracker.trackPageView();
                piwikTracker.enableLinkTracking();
        } catch( err ) {}
        </script>
        <!-- End Piwik Tag -->
        CODE
        tag.html_safe
      end
    end
  end
end
