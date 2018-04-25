Shader "Lecture/Texture_Animated"
{
	Properties 
	{
		_MainTex ("Base (RGB)", 2D) = "" {}	
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
			float4 _MainTex_ST;

			v2f vert(appdata v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.uv = TRANSFORM_TEX(v.uv, _MainTex);
				return o;
			}

			fixed4 frag(v2f i) : SV_TARGET
			{
				//Unity oferuje także zmienną zawierającą czas
				//_Time.x = _Time.y / 20.0
				//_Time.z = _Time.y * 2
				//_Time.w = _Time.y * 3
				//Dostępne są jeszcze _SinTime, _CosTime oraz unity_DeltaTime
				i.uv.y += _Time.y;
				fixed4 col = tex2D(_MainTex, i.uv);
				col.rgb *= col.a;
				return col;
			}
			ENDCG
		}
	}
}
