
from django.contrib.auth.decorators import login_required
from django.template import loader
from django.http import HttpResponse
from django.contrib.auth import get_user_model
from django.views.generic.edit import UpdateView
from django.urls import reverse
from api_core.models import BloodOxygenData, BloodSugarData, HeartBeatData, BloodPressureData, BodyTemperatureData, RespirationRateData

@login_required(login_url="/login/")
def index(request):
    
    context = {}
    context['segment'] = 'index'

    recent_employees = get_user_model().objects.all().order_by('-id')[:10].values('id','email', 'first_name', 'last_name')
    for i in recent_employees:
        i['bt'] = BodyTemperatureData.objects.filter(user=i['id']).order_by('-added_at')[:1].values('btdata')
        i['bs'] = BloodSugarData.objects.filter(user=i['id']).order_by('-added_at')[:1].values('bsdata')
        i['bo'] = BloodOxygenData.objects.filter(user=i['id']).order_by('-added_at')[:1].values('bodata')
        i['bp'] = BloodPressureData.objects.filter(user=i['id']).order_by('-added_at')[:1].values('bpdata')
        i['hb'] = HeartBeatData.objects.filter(user=i['id']).order_by('-added_at')[:1].values('hbdata')
        i['rr'] = RespirationRateData.objects.filter(user=i['id']).order_by('-added_at')[:1].values('rrdata')

    context['recent_employees'] = recent_employees
    # print(recent_employees)
    context['notifications'] = ['Warn the employees about their health hazards', '20 Employees may have prediabetes']
    context['notcount'] = len(context['notifications'])
    html_template = loader.get_template( 'index.html' )
    return HttpResponse(html_template.render(context, request))

@login_required(login_url='/login/')
def userList(request):
    query = get_user_model().objects.filter(is_staff=False)
    html_template = loader.get_template( 'ui-tables.html' )
    context = {}
    context['users'] = query.values('first_name', 'last_name', 'email')
    context['segment'] = 'user_list'
    return HttpResponse(html_template.render(context, request))

    
# @login_required(login_url='/login')
class ProfileView(UpdateView):
    model = get_user_model()
    fields = ('first_name', 'last_name', 'email')
    template_name = 'page-user.html'

    def get(self, request, *args, **kwargs):
        self.object = self.get_object()
        print(self.object)
        return super(ProfileView, self).get(request, *args, **kwargs)

    def get_success_url(self):
        if 'pk' in self.kwargs:
            slug = self.kwargs['pk']
            print(slug)
        return reverse('profile', kwargs={'pk': slug})

    def get_context_data(self, **kwargs):
        context = super(ProfileView, self).get_context_data(**kwargs)
        user_data = get_user_model().objects.filter(pk=self.kwargs['pk']).values('id', 'first_name', 'last_name', 'email')
        context['user_data'] = user_data[0]
        context['segment'] = 'profile'
        print(context)
        return context


