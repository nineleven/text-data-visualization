from django.shortcuts import render
from django.http import JsonResponse, HttpResponseNotFound
from django.views.decorators.csrf import csrf_exempt

from .models import SampleText

from .logic import encode_text

# Create your views here.

def get_available_texts_view(request):
    texts = SampleText.objects.all()
    return JsonResponse({'context': [text.name for text in texts]})
    
def get_text_view(request):
    if request.method == 'GET':
        text_name = request.GET['name'].replace('+', ' ')
        text = SampleText.objects.filter(name__startswith=text_name)[0]
        return JsonResponse({'context': text.text})
    return HttpResponseNotFound('Please, use GET method')

@csrf_exempt
def encode_text_view(request):
    if request.method == 'POST':
        text = request.body.decode('utf-8')
        words, codes = encode_text(text)

        return JsonResponse({'words': words,
                             'codes': codes})
    return HttpResponseNotFound('Please, use POST method')
