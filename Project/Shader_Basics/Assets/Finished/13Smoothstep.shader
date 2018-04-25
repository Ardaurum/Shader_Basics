Shader "Lecture/Smoothstep"
{
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

			v2f vert(appdata v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.uv = v.uv;
				return o;
			}

			fixed4 frag(v2f i) : SV_TARGET
			{
				//W przypadku, gdy mamy problem z zobrazowaniem jakiejś funkcji możemy ją wyrenderować
				//za pomocą shadera ustalając i.uv.x jako x naszej funkcji i porównując ją z i.uv.y
				//Smoothstep daje nam interpolację Hermite'a
				half value = smoothstep(0, 1, i.uv.x);
				clip((i.uv.y - value) * (value - i.uv.y) + 0.0001);
				return fixed4(1, 0, 0, 1);
			}
			ENDCG
		}
	}
}
