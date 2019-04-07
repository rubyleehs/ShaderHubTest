Shader "Custom/OutlineDistort"
{
	Properties//Variables
	{
		_DistortColor("Distort Color", Color) = (1,1,1,1)
		_BumpAmt("Distortion", Range(0,128)) = 10
		_DistortTex("Distort Texture (RGB)", 2D) = "white" {}
		_BumpMap("Normal Map", 2D) = "bump" {}
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
			Name "OutlineDistort"

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

			struct appdata//How the vertex function receives info.
			{
				float4 vertex : POSITION;
				float2 texcoord : TEXCOORD0;
			};

			struct v2f
			{
				float4 vertex : SV_POSITION;
				float4 uvgrab : TEXCOORD0;
				float2 uvbump : TEXCOORD1;
				float uvmain : TEXCOORD2;
			};

			//\===========================================================================================
			//\ Imports - Re-import property from shader lab to nvidia cg
			//\===========================================================================================

			float _BumpAmt;
			float4 _BumpMap_ST;
			float4 _DistortTex_ST;
			fixed4 _DistortColor;
			sampler2D _GrabTexture;
			float4 _GrabTexture_TexelSize;
			sampler2D _BumpMap;
			sampler2D _DistortTex;
			float _OutlineWidth;

			//\===========================================================================================
			//\ Vertex Function - Builds the object
			//\===========================================================================================

			v2f vert(appdata input)
			{
				v2f output;
				input.vertex.xyz *= _OutlineWidth;
				output.vertex = UnityObjectToClipPos(input.vertex);

				#if UNITY_UV_STARTS_AT_TOP
					float scale = -1.0;
				#else
					float scale = 1.0;
				#endif

				output.uvgrab.xy = (float2(output.vertex.x, output.vertex.y * scale) + output.vertex.w) * 0.5;
				output.uvgrab.zw = output.vertex.zw;

				output.uvbump = TRANSFORM_TEX(input.texcoord, _BumpMap);
				output.uvmain = TRANSFORM_TEX(input.texcoord, _DistortTex);

				return output;
			}

			//\===========================================================================================
			//\ Fragment Function - Color it in
			//\===========================================================================================

			half4 frag(v2f input) : COLOR
			{
				half2 bump = UnpackNormal(tex2D(_BumpMap, input.uvbump)).rg;
				float2 offset = bump * _BumpAmt * _GrabTexture_TexelSize.xy;
				input.uvgrab.xy = offset * input.uvgrab.z + input.uvgrab.xy;

				half4 col = tex2Dproj(_GrabTexture, UNITY_PROJ_COORD(input.uvgrab));
				half4 tint = tex2D(_DistortTex, input.uvmain) * _DistortColor;

				return col * tint;
			}

			ENDCG
		}
	}
}

