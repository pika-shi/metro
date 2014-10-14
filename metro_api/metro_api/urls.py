from django.conf.urls import patterns, include, url

from django.contrib import admin
admin.autodiscover()

urlpatterns = patterns('',
    # Examples:
    # url(r'^$', 'metro_api.views.home', name='home'),
    # url(r'^blog/', include('blog.urls')),

    url(r'^admin/', include(admin.site.urls)),
    url(r'^redis$', 'controller1.views.redis_check'),
    url(r'^neartrain/(?P<coord>.+)$', 'controller1.views.k_nearest_train'),
    url(r'^metron$', 'controller1.views.metro_now'),
)
