from django.contrib import admin
from django.contrib.auth.admin import UserAdmin

from . import models


class CustomUserAdmin(UserAdmin):
    model = models.CustomUser
    list_display = ('email', 'is_staff', 'is_active',)
    list_filter = ('email', 'is_staff', 'is_active',)
    fieldsets = (
        (None, {'fields': ('email', 'password', 'first_name', 'last_name')}),
        ('Permissions', {'fields': ('is_staff', 'is_active')}),
    )
    add_fieldsets = (
        (None, {
            'classes': ('wide',),
            'fields': ('email', 'password1', 'password2', 'is_staff', 'is_active')}
        ),
    )
    search_fields = ('email',)
    ordering = ('email',)

admin.site.register(models.CustomUser, CustomUserAdmin)

admin.site.register(models.BloodOxygenData)
admin.site.register(models.BloodPressureData)
admin.site.register(models.BloodSugarData)
admin.site.register(models.HeartBeatData)
admin.site.register(models.BodyTemperatureData)
admin.site.register(models.RespirationRateData)

admin.site.register(models.FileModel)