Shader "Custom/Healthbar"
{
    Properties
    {
        _Health ("Health" , Range(0,1)) = 1
        _BorderSize ("Border Size" , Range(0,0.5)) = 0.1

    }
    SubShader
    {
        Tags { "RenderType"="Transparent" "Queue" = "Transparent"  }

        Pass
        {
            ZWrite Off
            
            Blend SrcAlpha OneMinusSrcAlpha // Alpha Blending
            
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"

            struct MeshData
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct Interpolators
            {
                float2 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
            };

            sampler2D _MainTex;
            float _Health;
            float _BorderSize;

            float InverseLerp(float a, float b, float v )
            {
                return (v-a) / (b-a);
            }

            Interpolators vert (MeshData v)
            {
                Interpolators o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = v.uv;
                return o;
            }

            float4 frag (Interpolators i) : SV_Target
            {
                float2 coords = i.uv;
                coords.x *= 8;

                float2 pointOnLineSeg = float2( clamp(coords.x, 0.5,7.5)  , 0.5); // hardcoded midpoint on shape
                float sdf = distance(coords, pointOnLineSeg) * 2 -1;
                clip(-sdf);
                
                float borderSdf = sdf + _BorderSize;
                float borderMask = step(0,-borderSdf);

                float healthbarMask = _Health > i.uv.x;
                
                float tHealthColor = saturate(InverseLerp(0.2,0.8,_Health));
                
                float3 healtbarColor = lerp(float3(1,0,0),float3(0,1,0) ,tHealthColor);

                float flash = cos(_Time.y * 4) * 0.4 + 1; // +1 for color saturation
                if(_Health <= 0.2)
                {
                    healtbarColor *= flash;
                }
                
                return float4(healtbarColor * borderMask * healthbarMask , 1); 
            }
            ENDCG
        }
    }
}