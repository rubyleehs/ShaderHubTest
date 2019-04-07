Shader "Custom/OutlineBlur"
{
	Properties//Variables
	{
		_BlurRadius("Blur Radius", Range(0.0,20.0)) = 1
		_Intensity("Blur Intensity", Range(0.0,1.0)) = 0.01
		_OutlineWidth("Outline Width", Range(1.0,5.0)) = 1.05
	}

	SubShader
	{
		Tags 
		{
			"Queue" = "Transparent"
		}

		GrabPass{}

		Pass
		{
			Name "OutlineHorizontalBlur"
			ZWrite OFF
			CGPROGRAM//Allows talk between two languages: shader lab and nvidia C for graphics.

			//\===========================================================================================
			//\ Function Defines - defines the name for the vertex and fragment functions
			//\===========================================================================================

			#pragma vertex vert//Define for the building function.

			#pragma fragment frag//Define for coloring function.

			//\===========================================================================================
			//\ Includes
			//\===========================================================================================

			#include "UnityCG.cginc"//Built in shader functions.

			//\===========================================================================================
			//\ Structures - Can get data like - vertices's, normal, color, uv.
			//\===========================================================================================

			struct v2f
			{
				float4 vertex : SV_POSITION;
				float4 uvgrab : TEXCOORD0;
			};

			//\===========================================================================================
			//\ Imports - Re-import property from shader lab to nvidia cg
			//\===========================================================================================

			float _BlurRadius;
			float _Intensity;
			sampler2D _GrabTexture;
			float4 _GrabTexture_TexelSize;
			float _OutlineWidth;


			//\===========================================================================================
			//\ Vertex Function - Builds the object
			//\===========================================================================================

			v2f vert(appdata_base input)
			{
				v2f output;
				input.vertex.xyz *= _OutlineWidth + 0.1;
				output.vertex = UnityObjectToClipPos(input.vertex);

				#if UNITY_UV_STARTS_AT_TOP
					float scale = -1.0;
				#else
					float scale = 1.0;
				#endif

				output.uvgrab.xy = (float2(output.vertex.x, output.vertex.y * scale) + output.vertex.w) * 0.5;
				output.uvgrab.zw = output.vertex.zw;

				return output;
			}

			//\===========================================================================================
			//\ Fragment Function - Color it in
			//\===========================================================================================

			half4 frag(v2f input) : COLOR
			{
				half4 texcol = tex2Dproj(_GrabTexture, UNITY_PROJ_COORD(input.uvgrab));
				half4 texsum = half4(0, 0, 0, 0);

				#define GRABPIXEL(weight, kernelx) tex2Dproj(_GrabTexture, UNITY_PROJ_COORD(float4(input.uvgrab.x + _GrabTexture_TexelSize.x * kernelx * _BlurRadius, input.uvgrab.y,  input.uvgrab.z,  input.uvgrab.w))) * weight

				texsum += GRABPIXEL(0.05, -4.0);
				texsum += GRABPIXEL(0.09, -3.0);
				texsum += GRABPIXEL(0.12, -2.0);
				texsum += GRABPIXEL(0.15, -1.0);
				texsum += GRABPIXEL(0.18, 0.0);
				texsum += GRABPIXEL(0.15, 1.0);
				texsum += GRABPIXEL(0.12, 2.0);
				texsum += GRABPIXEL(0.09, 3.0);
				texsum += GRABPIXEL(0.05, 4.0);

				texcol = lerp(texcol, texsum, _Intensity);
				return texcol;
			}

			ENDCG
		}

		GrabPass{}

		Pass
		{
			Name "OutlineVerticalBlur"
			ZWrite OFF
			CGPROGRAM//Allows talk between two languages: shader lab and nvidia C for graphics.

			//\===========================================================================================
			//\ Function Defines - defines the name for the vertex and fragment functions
			//\===========================================================================================

			#pragma vertex vert//Define for the building function.

			#pragma fragment frag//Define for coloring function.

			//\===========================================================================================
			//\ Includes
			//\===========================================================================================

			#include "UnityCG.cginc"//Built in shader functions.

			//\===========================================================================================
			//\ Structures - Can get data like - vertices's, normal, color, uv.
			//\===========================================================================================
			
			struct v2f
			{
				float4 vertex : SV_POSITION;
				float4 uvgrab : TEXCOORD0;
			};

			//\===========================================================================================
			//\ Imports - Re-import property from shader lab to nvidia cg
			//\===========================================================================================

			float _BlurRadius;
			float _Intensity;
			sampler2D _GrabTexture;
			float4 _GrabTexture_TexelSize;
			float _OutlineWidth;

			//\===========================================================================================
			//\ Vertex Function - Builds the object
			//\===========================================================================================
			
			v2f vert(appdata_base input)
			{
				v2f output;
				input.vertex.xyz *= _OutlineWidth + 0.1;
				output.vertex = UnityObjectToClipPos(input.vertex);

				#if UNITY_UV_STARTS_AT_TOP
					float scale = -1.0;
				#else
					float scale = 1.0;
				#endif

				output.uvgrab.xy = (float2(output.vertex.x, output.vertex.y * scale) + output.vertex.w) * 0.5;
				output.uvgrab.zw = output.vertex.zw;

				return output;
			}

			//\===========================================================================================
			//\ Fragment Function - Color it in
			//\===========================================================================================

			half4 frag(v2f input) : COLOR
			{
				half4 texcol = tex2Dproj(_GrabTexture, UNITY_PROJ_COORD(input.uvgrab));
				half4 texsum = half4(0, 0, 0, 0);

				#define GRABPIXEL(weight, kernely) tex2Dproj(_GrabTexture, UNITY_PROJ_COORD(float4(input.uvgrab.x, input.uvgrab.y + _GrabTexture_TexelSize.y * kernely * _BlurRadius,  input.uvgrab.z,  input.uvgrab.w))) * weight
				
				texsum += GRABPIXEL(0.05, -4.0);
				texsum += GRABPIXEL(0.09, -3.0);
				texsum += GRABPIXEL(0.12, -2.0);
				texsum += GRABPIXEL(0.15, -1.0);
				texsum += GRABPIXEL(0.18, 0.0);
				texsum += GRABPIXEL(0.15, 1.0);
				texsum += GRABPIXEL(0.12, 2.0);
				texsum += GRABPIXEL(0.09, 3.0);
				texsum += GRABPIXEL(0.05, 4.0);

				texcol = lerp(texcol, texsum, _Intensity);
				return texcol;
			}

			ENDCG
		}
	}
}
