from django.shortcuts import render
from django.http import JsonResponse, HttpResponseNotFound
from django.views.decorators.csrf import csrf_exempt

from .logic import encode_text

# Create your views here.

def get_available_texts_view(request):
    return JsonResponse({'context': ['text1', 'text2']})
    
def get_text_view(request, text_name):
    return JsonResponse({'context': 'test text'})

@csrf_exempt
def encode_text_view(request):
    if request.method == 'POST':
        text = request.body.decode('utf-8')
        words, codes = encode_text(text)

        return JsonResponse({'words': words,
                             'codes': codes})
    return HttpResponseNotFound('Please, use POST method')
