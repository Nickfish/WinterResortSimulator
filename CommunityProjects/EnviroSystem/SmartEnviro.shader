
Shader "PaulchenShaders/SmartEnviro"
{
  Properties
  {
      _Color("Color", Color) = (1,1,1,1)
      _MainTex("Albedo (RGB)", 2D) = "white" {}
      _Metallic("Metallic", 2D) = "black" {}
      _Normal("Normal", 2D) = "white" {}
      _Height("Height", 2D) = "white" {}
      _Occlusion("Occlusion", 2D) = "white" {}
      //Snow
      _SnowTex("Snow Albedo (RGB)", 2D) = "white" {}
      _SnowNormal("Snow-Normal", 2D) = "white" {}
      _SnowDir("Snow Direction", Vector) = (0, 1, 0, 0)
      _SnowAmount("Snow Amount", Range(0,1)) = 0.2
      //Moss 
      _MossTex("Moss Albedo (RGB)", 2D) = "green" {}
      _MossNormal("Snow-Normal", 2D) = "white" {}
      _MossDir("Moss Direction", Vector) = (0, 1, 0, 0)
      _MossAmount("Moss Amount", Range(0,1)) = 0.2
  }
    SubShader
      {
          Tags { "RenderType" = "Opaque" }
          LOD 200

          CGPROGRAM
        // Physically based Standard lighting model, and enable shadows on all light types
        #pragma surface surf Standard fullforwardshadows

        #pragma target 5.0
        sampler2D _MainTex;
        sampler2D _SnowTex;
        sampler2D _MossTex;
        sampler2D _Metallic;
        sampler2D _Normal;
        sampler2D _SnowNormal;
        sampler2D _MossNormal;
        sampler2D _Height;
        sampler2D _Occlusion;

        struct Input
        {
            float2 uv_MainTex;
            float2 uv_SnowTex;
            float2 uv_MossTex;

            float3 worldNormal;
            INTERNAL_DATA
        };
        fixed4 _Color;

        float4 _SnowDir;
        float _SnowAmount;
  
        float4 _MossDir;
        float _MossAmount;

        // Add instancing support for this shader. You need to check 'Enable Instancing' on materials that use the shader.
        // See https://docs.unity3d.com/Manual/GPUInstancing.html for more information about instancing.
        // #pragma instancing_options assumeuniformscaling
        UNITY_INSTANCING_BUFFER_START(Props)
          // put more per-instance properties here
        UNITY_INSTANCING_BUFFER_END(Props)

      void surf(Input IN, inout SurfaceOutputStandard o)
      {
          // Setup objects normal value
          fixed3 normal = UnpackNormal(tex2D(_Normal, IN.uv_MainTex));

          fixed3 snowNormal = UnpackNormal(tex2D(_SnowNormal, IN.uv_SnowTex));
          fixed3 mossNormal = UnpackNormal(tex2D(_MossNormal, IN.uv_MossTex));
          //snow
          float3 worldNormal  = WorldNormalVector(IN, normal.rgb);
          float snowCoverage  = 1 - ((dot(worldNormal, _SnowDir) + 1) / 2);
          float snowStrength  = snowCoverage < _SnowAmount;
          //moss
          float mossCoverage  = 1 - ((dot(worldNormal, _MossDir) + 1) / 2);
          float mossStrength  = mossCoverage < _MossAmount;

          fixed4 snowColor    = tex2D(_SnowTex, IN.uv_MainTex);
          fixed4 mossColor    = tex2D(_MossTex, IN.uv_MainTex);

          fixed4 c            = tex2D(_MainTex, IN.uv_MainTex) * _Color;
          fixed4 metallic     = tex2D(_Metallic, IN.uv_MainTex);
          fixed4 occlusion    = tex2D(_Occlusion, IN.uv_MainTex);

          o.Albedo =(c*(1 - snowStrength) + snowColor * snowStrength) + (c*(1 - mossStrength) + mossColor * mossStrength);
          o.Normal = normal.rgb + ((1 - snowStrength) + snowNormal * snowStrength) * ((1 - mossStrength) + mossNormal * mossStrength);
          o.Metallic = metallic.r;
          o.Occlusion = occlusion.r;
          o.Alpha = c.a;
      }
      ENDCG
      }
      FallBack "Diffuse"
}