Shader "Custom/VertexInline"
{
	Properties //It's like exposing properties to inspector
	{
		_MainTex("Texture", 2D) = "white" {} //Allows for a texture property
		_Color("Color", Color) = (1,1,1,1)

		_OutlineTex("Outline Texture", 2D) = "white" {}
		_OutlineColor("Outline Color", Color) = (0,0,0,1)
		_OutlineWidth("Outline Width", Range(1.0,5.0)) = 1.05
	}

		SubShader
		{
			Tags
			{
				"Queue" = "Transparent"
			}

			GrabPass{}
			//Pass #1 - Render Outline
			Pass
			{
				Name "InlinePass"

				ZWrite Off
				ZTest LEqual
				Blend DstAlpha OneMinusDstAlpha, Zero One

				CGPROGRAM//Allows talk between 2 languages: shader lab and Nvidia CG for graphics 

				//\==================================================================================
				//\ Function Defines - Defines the name for the vertex and fragment functions
				//\==================================================================================

				//Define for the building function aka shape etc
				#pragma vertex vert 

				//Define for the coloring function aka alpha
				#pragma fragment frag

				//\==================================================================================
				//\ Includes
				//\==================================================================================

				//Library for shader functions
				#include "UnityCG.cginc"

				//\==================================================================================
				//\ Structures - Your typical structures
				//\==================================================================================

				struct appdata
				{
					float4 vertex: POSITION;
					float2 uv : TEXCOORD0;
				};

				struct v2f
				{
					float4 pos : SV_POSITION;
					float2 uv: TEXCOORD0;
				};

				//\==================================================================================
				//\ Imports - Inports properties from shader lab to Nvidia CG
				//\==================================================================================

				//Plus you can have variable declarations

				sampler2D _OutlineTex;
				float4 _OutlineColor;
				float _OutlineWidth;

				//\==================================================================================
				//\ Functions
				//\==================================================================================

				//Vertex Function - building function for shape etc
				v2f vert(appdata input)
				{
					input.vertex.xyz *= _OutlineWidth;
					v2f output;

					output.pos = UnityObjectToClipPos(input.vertex); //Convert from obj space to cam space
					output.uv = input.uv;

					return output;
				}

				//Fragment Function - Color and jazz
				// ":SV_TARGET" is telling what the output will be used for
				fixed4 frag(v2f input) : SV_Target
				{
					float4 texColor = tex2D(_OutlineTex, input.uv); //wraps _MainTex according to input.uv on obj

					return texColor * _OutlineColor;
				}
				ENDCG
			}


			//Pass #2 - Render Object + Apply Texture

			Tags { "Queue" = "Geometry" }
			Lighting Off
		
			BindChannels
			{
				Bind "Color", color
				Bind "Vertex", vertex
			}

			Pass
			{
				Name "ObjectPass"
				CGPROGRAM//Allows talk between 2 languages: shader lab and Nvidia CG for graphics 

				//\==================================================================================
				//\ Function Defines - Defines the name for the vertex and fragment functions
				//\==================================================================================

				//Define for the building function aka shape etc
				#pragma vertex vert 

				//Define for the coloring function aka alpha
				#pragma fragment frag

				//\==================================================================================
				//\ Includes
				//\==================================================================================

				//Library for shader functions
				#include "UnityCG.cginc"

				//\==================================================================================
				//\ Structures - Your typical structures
				//\==================================================================================

				struct appdata
				{
					float4 vertex: POSITION;
					float2 uv : TEXCOORD0;
					float4 color : COLOR;
				};

				struct v2f
				{
					float4 pos : SV_POSITION;
					float2 uv: TEXCOORD0;
					float4 color : COLOR;
				};

				//\==================================================================================
				//\ Imports - Inports properties from shader lab to Nvidia CG
				//\==================================================================================

				//Plus you can have variable declarations

				float4 _Color;
				sampler2D _MainTex;

				//\==================================================================================
				//\ Functions
				//\==================================================================================

				//Vertex Function - building function for shape etc
				v2f vert(appdata input)
				{
					v2f output;

					output.pos = UnityObjectToClipPos(input.vertex); //Convert from obj space to cam space
					output.uv = input.uv;
					output.color = input.color;
					return output;
				}

				//Fragment Function - Color and jazz
				// ":SV_TARGET" is telling what the output will be used for
				fixed4 frag(v2f input) : SV_Target
				{
					float4 texColor = tex2D(_MainTex, input.uv); //wraps _MainTex according to input.uv on obj

					return texColor * _Color * input.color;
				}
				ENDCG
			}
		}
}