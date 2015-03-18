// Shader created with Shader Forge Beta 0.36 
// Shader Forge (c) Joachim Holmer - http://www.acegikmo.com/shaderforge/
// Note: Manually altering this data may prevent you from opening it in Shader Forge
/*SF_DATA;ver:0.36;sub:START;pass:START;ps:flbk:,lico:1,lgpr:1,nrmq:1,limd:1,uamb:True,mssp:True,lmpd:False,lprd:False,enco:False,frtr:True,vitr:True,dbil:False,rmgx:True,rpth:0,hqsc:True,hqlp:False,tesm:0,blpr:2,bsrc:0,bdst:0,culm:2,dpts:2,wrdp:False,ufog:True,aust:True,igpj:True,qofs:0,qpre:3,rntp:2,fgom:False,fgoc:False,fgod:False,fgor:False,fgmd:0,fgcr:0,fgcg:0.1082872,fgcb:0.1865672,fgca:1,fgde:0.01,fgrn:0,fgrf:300,ofsf:0,ofsu:0,f2p0:False;n:type:ShaderForge.SFN_Final,id:1,x:34004,y:32587|diff-4-OUT,emission-4-OUT;n:type:ShaderForge.SFN_Tex2d,id:2,x:33354,y:32402,ptlb:_WaterBack,ptin:__WaterBack,tex:26bacafbb4599a14b899d62abbf329bc,ntxv:0,isnm:False|UVIN-15-UVOUT;n:type:ShaderForge.SFN_Tex2d,id:3,x:33493,y:32716,ptlb:_WaterFront,ptin:__WaterFront,tex:4c220a61d5d9ff84c9afd7ec5f1f75aa,ntxv:0,isnm:False|UVIN-26-UVOUT;n:type:ShaderForge.SFN_Add,id:4,x:33691,y:32579|A-57-OUT,B-3-RGB;n:type:ShaderForge.SFN_Panner,id:15,x:33216,y:32526,spu:0,spv:1|DIST-47-OUT;n:type:ShaderForge.SFN_Panner,id:26,x:33216,y:32707,spu:0,spv:1|DIST-45-OUT;n:type:ShaderForge.SFN_Time,id:37,x:32724,y:32487;n:type:ShaderForge.SFN_Multiply,id:45,x:32967,y:32707|A-37-TTR,B-46-OUT;n:type:ShaderForge.SFN_Slider,id:46,x:32710,y:32952,ptlb:_WaterSpeed,ptin:__WaterSpeed,min:0,cur:0.08878734,max:1;n:type:ShaderForge.SFN_Multiply,id:47,x:32966,y:32443|A-37-TDB,B-46-OUT;n:type:ShaderForge.SFN_Multiply,id:57,x:33579,y:32457|A-2-RGB,B-58-RGB;n:type:ShaderForge.SFN_Color,id:58,x:33341,y:32592,ptlb:_WaterTint,ptin:__WaterTint,glob:False,c1:0.5,c2:0.5,c3:0.5,c4:1;proporder:2-3-46-58;pass:END;sub:END;*/

Shader "Shader Forge/WaterFall1" {
    Properties {
        __WaterBack ("_WaterBack", 2D) = "white" {}
        __WaterFront ("_WaterFront", 2D) = "white" {}
        __WaterSpeed ("_WaterSpeed", Range(0, 1)) = 0.08878734
        __WaterTint ("_WaterTint", Color) = (0.5,0.5,0.5,1)
    }
    SubShader {
        Tags {
            "IgnoreProjector"="True"
            "Queue"="Transparent"
            "RenderType"="Transparent"
        }
        Pass {
            Name "ForwardBase"
            Tags {
                "LightMode"="ForwardBase"
            }
            Blend One One
            Cull Off
            ZWrite Off
            
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #define UNITY_PASS_FORWARDBASE
            #include "UnityCG.cginc"
            #pragma multi_compile_fwdbase
            #pragma exclude_renderers xbox360 ps3 flash 
            #pragma target 3.0
            uniform float4 _LightColor0;
            uniform float4 _TimeEditor;
            uniform sampler2D __WaterBack; uniform float4 __WaterBack_ST;
            uniform sampler2D __WaterFront; uniform float4 __WaterFront_ST;
            uniform float __WaterSpeed;
            uniform float4 __WaterTint;
            struct VertexInput {
                float4 vertex : POSITION;
                float3 normal : NORMAL;
                float2 texcoord0 : TEXCOORD0;
            };
            struct VertexOutput {
                float4 pos : SV_POSITION;
                float2 uv0 : TEXCOORD0;
                float4 posWorld : TEXCOORD1;
                float3 normalDir : TEXCOORD2;
            };
            VertexOutput vert (VertexInput v) {
                VertexOutput o;
                o.uv0 = v.texcoord0;
                o.normalDir = mul(float4(v.normal,0), _World2Object).xyz;
                o.posWorld = mul(_Object2World, v.vertex);
                o.pos = mul(UNITY_MATRIX_MVP, v.vertex);
                return o;
            }
            fixed4 frag(VertexOutput i) : COLOR {
                i.normalDir = normalize(i.normalDir);
                float3 viewDirection = normalize(_WorldSpaceCameraPos.xyz - i.posWorld.xyz);
/////// Normals:
                float3 normalDirection =  i.normalDir;
                
                float nSign = sign( dot( viewDirection, i.normalDir ) ); // Reverse normal if this is a backface
                i.normalDir *= nSign;
                normalDirection *= nSign;
                
                float3 lightDirection = normalize(_WorldSpaceLightPos0.xyz);
////// Lighting:
                float attenuation = 1;
                float3 attenColor = attenuation * _LightColor0.xyz;
/////// Diffuse:
                float NdotL = dot( normalDirection, lightDirection );
                float3 diffuse = max( 0.0, NdotL) * attenColor + UNITY_LIGHTMODEL_AMBIENT.rgb;
////// Emissive:
                float4 node_37 = _Time + _TimeEditor;
                float2 node_77 = i.uv0;
                float2 node_15 = (node_77.rg+(node_37.b*__WaterSpeed)*float2(0,1));
                float2 node_26 = (node_77.rg+(node_37.a*__WaterSpeed)*float2(0,1));
                float3 node_4 = ((tex2D(__WaterBack,TRANSFORM_TEX(node_15, __WaterBack)).rgb*__WaterTint.rgb)+tex2D(__WaterFront,TRANSFORM_TEX(node_26, __WaterFront)).rgb);
                float3 emissive = node_4;
                float3 finalColor = 0;
                float3 diffuseLight = diffuse;
                finalColor += diffuseLight * node_4;
                finalColor += emissive;
/// Final Color:
                return fixed4(finalColor,1);
            }
            ENDCG
        }
        Pass {
            Name "ForwardAdd"
            Tags {
                "LightMode"="ForwardAdd"
            }
            Blend One One
            Cull Off
            ZWrite Off
            
            Fog { Color (0,0,0,0) }
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #define UNITY_PASS_FORWARDADD
            #include "UnityCG.cginc"
            #include "AutoLight.cginc"
            #pragma multi_compile_fwdadd
            #pragma exclude_renderers xbox360 ps3 flash 
            #pragma target 3.0
            uniform float4 _LightColor0;
            uniform float4 _TimeEditor;
            uniform sampler2D __WaterBack; uniform float4 __WaterBack_ST;
            uniform sampler2D __WaterFront; uniform float4 __WaterFront_ST;
            uniform float __WaterSpeed;
            uniform float4 __WaterTint;
            struct VertexInput {
                float4 vertex : POSITION;
                float3 normal : NORMAL;
                float2 texcoord0 : TEXCOORD0;
            };
            struct VertexOutput {
                float4 pos : SV_POSITION;
                float2 uv0 : TEXCOORD0;
                float4 posWorld : TEXCOORD1;
                float3 normalDir : TEXCOORD2;
                LIGHTING_COORDS(3,4)
            };
            VertexOutput vert (VertexInput v) {
                VertexOutput o;
                o.uv0 = v.texcoord0;
                o.normalDir = mul(float4(v.normal,0), _World2Object).xyz;
                o.posWorld = mul(_Object2World, v.vertex);
                o.pos = mul(UNITY_MATRIX_MVP, v.vertex);
                TRANSFER_VERTEX_TO_FRAGMENT(o)
                return o;
            }
            fixed4 frag(VertexOutput i) : COLOR {
                i.normalDir = normalize(i.normalDir);
                float3 viewDirection = normalize(_WorldSpaceCameraPos.xyz - i.posWorld.xyz);
/////// Normals:
                float3 normalDirection =  i.normalDir;
                
                float nSign = sign( dot( viewDirection, i.normalDir ) ); // Reverse normal if this is a backface
                i.normalDir *= nSign;
                normalDirection *= nSign;
                
                float3 lightDirection = normalize(lerp(_WorldSpaceLightPos0.xyz, _WorldSpaceLightPos0.xyz - i.posWorld.xyz,_WorldSpaceLightPos0.w));
////// Lighting:
                float attenuation = LIGHT_ATTENUATION(i);
                float3 attenColor = attenuation * _LightColor0.xyz;
/////// Diffuse:
                float NdotL = dot( normalDirection, lightDirection );
                float3 diffuse = max( 0.0, NdotL) * attenColor;
                float3 finalColor = 0;
                float3 diffuseLight = diffuse;
                float4 node_37 = _Time + _TimeEditor;
                float2 node_78 = i.uv0;
                float2 node_15 = (node_78.rg+(node_37.b*__WaterSpeed)*float2(0,1));
                float2 node_26 = (node_78.rg+(node_37.a*__WaterSpeed)*float2(0,1));
                float3 node_4 = ((tex2D(__WaterBack,TRANSFORM_TEX(node_15, __WaterBack)).rgb*__WaterTint.rgb)+tex2D(__WaterFront,TRANSFORM_TEX(node_26, __WaterFront)).rgb);
                finalColor += diffuseLight * node_4;
/// Final Color:
                return fixed4(finalColor * 1,0);
            }
            ENDCG
        }
    }
    FallBack "Diffuse"
    CustomEditor "ShaderForgeMaterialInspector"
}
