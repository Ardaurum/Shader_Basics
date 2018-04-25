Shader "Lecture/Texture_Blending_Add"
{
	Properties 
	{
		_MainTex ("Base (RGB)", 2D) = "" {}	
		_SecondTex ("Secondary (RGB)", 2D) = "" {}
		_MainFactor ("Main Factor", Range(0, 1)) = 1
		_SecondFactor ("Second Factor", Range(0, 1)) = 1
	}

	SubShader
	{
		Pass {
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#include "UnityCG.cginc"

			struct appdata {
				float4 vertex : POSITION;
				float2 uv : TEXCOORD0;
			};

			struct v2f {
				float4 vertex : SV_POSITION;
				float2 uv : TEXCOORD0;
			};

			sampler2D _MainTex;
			sampler2D _SecondTex;
			float4 _MainTex_ST;
			half _MainFactor;
			half _SecondFactor;

			v2f vert(appdata v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.uv = TRANSFORM_TEX(v.uv, _MainTex);
				return o;
			}

			fixed4 frag(v2f i) : SV_TARGET
			{
				fixed4 col = tex2D(_MainTex, i.uv) * _MainFactor;
				col.rgb *= col.a;

				fixed4 col2 = tex2D(_SecondTex, i.uv) * _SecondFactor;
				col2.rgb *= col2.a;

				//Zwykłe dodanie dwóch tekstur podobna zasada do Blend One One
				return col + col2;
			}
			ENDCG
		}
	}
}
