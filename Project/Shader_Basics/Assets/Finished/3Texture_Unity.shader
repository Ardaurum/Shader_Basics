Shader "Lecture/Texture_Unity"
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

			//Dodajemy plik z przydatnymi funkcjami do shaderów od Unity
			//Domyślnie dostępny. Źródło jest dostępne na stronie Unity
			//https://unity3d.com/get-unity/download/archive - BuiltIn Shaders
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

			//ST od Scale oraz Translation, który w edytorze nazwane są Tiling (Scale)
			//oraz Offset (Translation). Automatycznie uzupełniane przez Unity.
			float4 _MainTex_ST;

			v2f vert(appdata v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				//#define TRANSFORM_TEX(tex,name) (tex.xy * name##_ST.xy + name##_ST.zw)
				o.uv = TRANSFORM_TEX(v.uv, _MainTex);
				return o;
			}

			fixed4 frag(v2f i) : SV_TARGET
			{
				fixed4 col = tex2D(_MainTex, i.uv);
				col.rgb *= col.a;
				return col;
			}
			ENDCG
		}
	}
}
