from django.shortcuts import render
from django.http import JsonResponse

# Create your views here.

def get_available_texts(request):
    return JsonResponse({'context': ['text1', 'text2']})
    
def get_text(request, text_name):
    return JsonResponse({'context': 'test text'})
    
