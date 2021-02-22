

from django.urls import path, re_path
from app import views

urlpatterns = [

    path('', views.index, name='home'),
    path('users/', views.userList, name='user_list' ),
    path('profile/<pk>/', views.ProfileView.as_view(), name='profile')
    # re_path(r'^.*\.*', views.pages, name='pages'),

]
