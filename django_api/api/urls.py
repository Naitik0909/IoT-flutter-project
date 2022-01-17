from django.contrib import admin
from django.urls import path
from .views import getReducedGrid

urlpatterns = [
    path('getReducedGrid/', getReducedGrid, name='getReducedGrid')
]
