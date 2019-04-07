Shader "Custom/FinalOutline"
{
    Properties //It's like exposing properties to inspector
    {
        _MainTex ("Texture", 2D) = "white" {} //Allows for a texture property
        _Color ("Color", Color) = (1,1,1,1)

        _BlurRadius("Blur Radius", Range(0.0,20.0)) = 1
		_Intensity("Blur Intensity", Range(0.0,1.0)) = 0.01
		_OutlineWidth("Outline Width", Range(1.0,5.0)) = 1.05

        _DistortColor("Distort Color", Color) = (1,1,1,1)
		_BumpAmt("Distortion", Range(0,128)) = 10
		_DistortTex("Distort Texture (RGB)", 2D) = "white" {}
		_BumpMap("Normal Map", 2D) = "bump" {}
    }
    
    SubShader
    {
        Tags
        {
            "Queue" = "Transparent"
        }
        
        GrabPass{}
        UsePass "Custom/OutlineDistort/OutlineDistort"
        GrabPass{}
        UsePass "Custom/OutlineBlur/OutlineHorizontalBlur"
        GrabPass{}
        UsePass "Custom/OutlineBlur/OutlineVerticalBlur"
        UsePass "Custom/Outline/ObjectPass"
    }
}
