from django import urls
from django.contrib.auth.base_user import BaseUserManager
from django.utils.translation import ugettext_lazy as _
from django.contrib.auth import get_user_model


class CustomUserManager(BaseUserManager):
    """
    Custom user model manager where email is the unique identifiers
    for authentication instead of usernames.
    """
    def create_user(self, email, password, **extra_fields):
        """
        Create and save a User with the given email and password.
        """
        if not email:
            raise ValueError(_('The Email must be set'))
        email = self.normalize_email(email)
        user = self.model(email=email, **extra_fields)
        user.set_password(password)
        user.save()
        return user

    def create_superuser(self, email, password, **extra_fields):
        """
        Create and save a SuperUser with the given email and password.
        """
        extra_fields.setdefault('is_staff', True)
        extra_fields.setdefault('is_superuser', True)
        extra_fields.setdefault('is_active', True)

        if extra_fields.get('is_staff') is not True:
            raise ValueError(_('Superuser must have is_staff=True.'))
        if extra_fields.get('is_superuser') is not True:
            raise ValueError(_('Superuser must have is_superuser=True.'))
        return self.create_user(email, password, **extra_fields)

from django.db import models
from django.contrib.auth.models import AbstractUser


class CustomUser(AbstractUser):
    username = None
    email = models.EmailField(_('email address'), unique=True)
    first_name = models.CharField(max_length=100)
    last_name = models.CharField(max_length=100)

    USERNAME_FIELD = 'email'
    REQUIRED_FIELDS = []

    objects = CustomUserManager()

    def __str__(self):
        return self.email


class BloodPressureData(models.Model):
    user = models.ForeignKey(get_user_model(), on_delete=models.DO_NOTHING)
    bpdata = models.FloatField()
    added_at = models.DateTimeField(auto_now_add=True)

    def __str__(self) -> str:
        return f'{self.user} {self.bpdata}'


class BodyTemperatureData(models.Model):
    user = models.ForeignKey(get_user_model(), on_delete=models.DO_NOTHING)
    btdata = models.FloatField()
    added_at = models.DateTimeField(auto_now_add=True)

    def __str__(self) -> str:
        return f'{self.user} {self.btdata}'


class BloodSugarData(models.Model):
    user = models.ForeignKey(get_user_model(), on_delete=models.DO_NOTHING)
    bsdata = models.FloatField()
    added_at = models.DateTimeField(auto_now_add=True)

    def __str__(self) -> str:
        return f'{self.user} {self.bsdata}'

class BloodOxygenData(models.Model):
    user = models.ForeignKey(get_user_model(), on_delete=models.DO_NOTHING)
    bodata = models.FloatField()
    added_at = models.DateTimeField(auto_now_add=True)

    def __str__(self) -> str:
        return f'{self.user} {self.bodata}'

class HeartBeatData(models.Model):
    user = models.ForeignKey(get_user_model(), on_delete=models.DO_NOTHING)
    hbdata = models.IntegerField()
    added_at = models.DateTimeField(auto_now_add=True)

    def __str__(self) -> str:
        return f'{self.user} {self.hbdata}'


class RespirationRateData(models.Model):
    user = models.ForeignKey(get_user_model(), on_delete=models.DO_NOTHING)
    rrdata = models.IntegerField()
    added_at = models.DateTimeField(auto_now_add=True)

    def __str__(self) -> str:
        return f'{self.user} {self.rrdata}'

    
class FileModel(models.Model):
    file = models.FileField(upload_to='uploaded_files/', default='')
    