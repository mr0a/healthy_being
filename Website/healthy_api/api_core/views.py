import random
from django.contrib.auth import views as auth_views
from django.http.response import HttpResponse
from django.views import generic
from django.urls import reverse_lazy
from django.views.decorators.csrf import csrf_exempt
from django.utils.decorators import method_decorator
from django.views.generic.base import View

from rest_framework import generics
from rest_framework.permissions import AllowAny
from django.contrib.auth import get_user_model
from .serializers import UserSerializer


from rest_framework.authentication import SessionAuthentication, BasicAuthentication
from rest_framework_simplejwt.authentication import JWTAuthentication
from rest_framework.permissions import IsAuthenticated
from rest_framework.response import Response
from rest_framework.views import APIView

from .forms import LoginForm, RegisterForm
from . import models


class LoginView(auth_views.LoginView):
    form_class = LoginForm
    template_name = 'api_core/login.html'


class RegisterView(generic.CreateView):
    form_class = RegisterForm
    template_name = 'api_core/register.html'
    success_url = reverse_lazy('login')


class UserCreateAPIView(generics.CreateAPIView):
    User = get_user_model()
    queryset = User.objects.all()
    serializer_class = UserSerializer
    permission_classes = (AllowAny,)


class ExampleView(APIView):
    authentication_classes = [SessionAuthentication,
                              BasicAuthentication, JWTAuthentication]
    permission_classes = [IsAuthenticated]

    def get(self, request, format=None):
        content = {
            'user': str(request.user),  # `django.contrib.auth.User` instance.
            'auth': str(request.auth),  # None
            'content': 'Hello User',
        }
        return Response(content)


class UserHealthDataView(APIView):
    # authentication_classes = [JWTAuthentication, SessionAuthentication]
    # permission_classes = [IsAuthenticated]
    queryset = get_user_model().objects.all()

    def get(self, request, format=None):
        content = {
            'btdata': random.randint(80, 100),
            'bpdata': random.randint(80, 100),
            'respdata': random.randint(80, 100),
            'bsdata': random.randint(80, 100),
            'hrdata': random.randint(80, 100),
            'srdata': random.randint(80, 100),

        }
        return Response(content)

@method_decorator(csrf_exempt, name='dispatch')
class FileUploadView(View):

    def post(self, request):
        file_model = models.FileModel()
        _, file = request.FILES.popitem()  # get first element of the uploaded files

        file = file[0]  # get the file from MultiValueDict

        file_model.file = file
        file_model.save()

        return HttpResponse(content_type='text/plain', content='File uploaded')



from .forms import LoginForm, SignUpForm
from django.shortcuts import render, redirect
from django.contrib.auth import authenticate, login

def login_view(request):
    form = LoginForm(request.POST or None)

    msg = None

    if request.method == "POST":

        if form.is_valid():
            username = form.cleaned_data.get("username")
            password = form.cleaned_data.get("password")
            user = authenticate(username=username, password=password)
            if user is not None:
                login(request, user)
                return redirect("/")
            else:    
                msg = 'Invalid credentials'    
        else:
            msg = 'Error validating the form'    

    return render(request, "accounts/login.html", {"form": form, "msg" : msg})

def register_user(request):

    msg     = None
    success = False

    if request.method == "POST":
        form = SignUpForm(request.POST)
        if form.is_valid():
            form.save()
            username = form.cleaned_data.get("username")
            raw_password = form.cleaned_data.get("password1")
            user = authenticate(username=username, password=raw_password)

            msg     = 'User created - please <a href="/login">login</a>.'
            success = True
            
            #return redirect("/login/")

        else:
            msg = 'Form is not valid'    
    else:
        form = SignUpForm()

    return render(request, "accounts/register.html", {"form": form, "msg" : msg, "success" : success })


def dataAdd(req, user, dataname, data):
    if dataname == 'bp':
        dbData = models.BloodPressureData()
        dbData.bpdata = data
    elif dataname == 'bo':
        dbData = models.BloodOxygenData()
        dbData.bodata = data
    elif dataname == 'bs':
        dbData = models.BloodSugarData()
        dbData.bsdata = data
    elif dataname == 'bt':
        dbData = models.BodyTemperatureData()
        dbData.btdata = data
    elif dataname == 'rr':
        dbData = models.RespirationRateData()
        dbData.rrdata = data
    elif dataname == 'hb':
        dbData = models.HeartBeatData()
        dbData.hbdata = data
    model = get_user_model()
    dbData.user = model(pk=user)
    dbData.save()
    print(dbData)
    return HttpResponse(req, 'data added')
