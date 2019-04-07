Shader "Custom/ApplyTexture"
{
    Properties //It's like exposing properties to inspector
    {
        _MainTex ("Texture", 2D) = "white" {} //Allows for a texture property
        _Color ("Color", Color) = (1,1,1,1)
    }
    
    SubShader
    {
        Pass
        {
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

                return output;
            }

            //Fragment Function - Color and jazz
            // ":SV_TARGET" is telling what the output will be used for
            fixed4 frag(v2f input) : SV_Target
            {
                float4 texColor = tex2D(_MainTex, input.uv); //wraps _MainTex according to input.uv on obj

                return texColor * _Color;
            }
            ENDCG
        }
    }
}
