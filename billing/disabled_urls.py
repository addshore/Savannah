from django.urls import path

from . import disabled_views


app_name = 'billing'
urlpatterns = [
    path("signup/new/", disabled_views.signup, name="signup"),
    path("signup/<int:community_id>/", disabled_views.signup_org, name="signup_org"),
    path("signup/<int:community_id>/subscribe", disabled_views.signup_subscribe, name="signup_subscribe"),
    path("signup/<int:community_id>/session", disabled_views.signup_subscribe_session, name="signup_subscribe_session"),
    path("signup/<int:community_id>/success", disabled_views.subscription_success, name="subscription_success"),
    path("signup/<int:community_id>/cancel", disabled_views.subscription_cancel, name="subscription_cancel"),
    path("manage/<int:community_id>/", disabled_views.manage_account, name="manage_account"),
    path("upgrade/<int:community_id>/", disabled_views.upgrade, name="upgrade"),
]