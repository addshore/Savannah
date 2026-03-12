from django import forms
from django.contrib import messages
from django.contrib.auth.decorators import login_required
from django.http import JsonResponse
from django.shortcuts import redirect, render

from corm.models import Community


class NewCommunityForm(forms.ModelForm):
    class Meta:
        model = Community
        fields = ['name', 'logo']


def _billing_disabled_redirect(request):
    messages.info(request, "Billing is disabled in this environment.")
    return redirect('home')


@login_required
def signup(request):
    community = Community(owner=request.user)
    if request.method == "POST":
        form = NewCommunityForm(request.POST, files=request.FILES, instance=community)
        if form.is_valid():
            new_community = form.save(commit=False)
            new_community.status = Community.DEVELOPMENT
            new_community.save()
            new_community.bootstrap()
            messages.success(request, "Community created in free self-hosted mode.")
            return redirect('dashboard', community_id=new_community.id)
    else:
        form = NewCommunityForm(instance=community)

    return render(request, 'billing/signup_community.html', {'form': form})


@login_required
def signup_org(request, community_id):
    return _billing_disabled_redirect(request)


@login_required
def signup_subscribe(request, community_id):
    return _billing_disabled_redirect(request)


@login_required
def signup_subscribe_session(request, community_id):
    return JsonResponse({'error': 'Billing is disabled in this environment.'}, status=400)


@login_required
def subscription_success(request, community_id):
    return _billing_disabled_redirect(request)


@login_required
def subscription_cancel(request, community_id):
    return _billing_disabled_redirect(request)


@login_required
def manage_account(request, community_id):
    return _billing_disabled_redirect(request)


@login_required
def upgrade(request, community_id):
    return _billing_disabled_redirect(request)