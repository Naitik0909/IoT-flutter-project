from django.shortcuts import render
from django.http import HttpResponse
from rest_framework.response import Response
from rest_framework import status
from rest_framework.decorators import api_view
from django.core.files.storage import default_storage
import cv2
import os

# Create your views here.
@api_view(['GET'])
def getReducedGrid(request):
    if request.method=='GET':
        try:
            img = request.FILES.get('img')
            img_name = str(request.FILES.get('img').name)
            with default_storage.open('images/'+img_name, 'wb+') as destination:
                for chunk in img.chunks():
                    destination.write(chunk)
            image = cv2.imread('images/'+img_name)
            image = cv2.resize(image, (10, 30), interpolation=cv2.INTER_AREA)
            image = cv2.cvtColor(image, cv2.COLOR_BGR2RGB)
            os.remove('images/'+img_name)
        except Exception as e:
            print(e)
            return Response("Bad request", status=status.HTTP_400_BAD_REQUEST)
    return Response({'image':image}, status=status.HTTP_200_OK)

