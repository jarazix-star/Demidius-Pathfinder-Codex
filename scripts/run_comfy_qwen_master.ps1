param(
    [Parameter(Mandatory)]
    [string]$Prompt,

    [Parameter(Mandatory)]
    [string]$OutputPath,

    [long]$Seed = (Get-Random -Minimum 1 -Maximum 2147483647),
    [int]$Width = 1472,
    [int]$Height = 1104,
    [int]$TimeoutSeconds = 420,
    [string]$Server = 'http://127.0.0.1:8188',
    [string]$FilenamePrefix = 'Codex-Qwen-2512',
    [switch]$QueueOnly
)

$ErrorActionPreference = 'Stop'

$negative = @'
bad hands, extra fingers, fused fingers, missing fingers, distorted face, identity drift, costume change, wardrobe change, random accessories, wrong eye color, wrong hair color, wrong species, extra weapons, duplicate equipment, floating text, misspelled labels, garbled letters, watermark, logo, blurry, low quality, child, nude, nsfw, bad anatomy, deformed, disfigured, mutated, poorly drawn hands, too many fingers, extra limbs, missing limbs, floating limbs, disconnected limbs, malformed hands, bad proportions, long neck, cross-eyed, asymmetrical eyes, blurry face, duplicate face, cloned face, extra head, worst quality, lowres, jpeg artifacts, compression artifacts, noise, grainy, out of focus, oversharpened, oversaturated, underexposed, overexposed, banding, chromatic aberration, signature, text, subtitle, UI, interface, username, timestamp, photorealistic skin pores, documentary photo, smartphone snapshot, chibi, comic panel borders, manga screentones, 3d render, cgi, plastic skin, uncanny valley, warhammer bulk, modern streetwear, corporate office, neon cyberpunk city, random jewelry clutter, excessive particles, unmotivated glow, lens flare spam, explicit, sexualized pose, loli, shota, underage, toddler
'@

$graph = @{
    '1' = @{
        class_type = 'UNETLoader'
        inputs = @{
            unet_name = 'qwen_image_2512_fp8_e4m3fn.safetensors'
            weight_dtype = 'default'
        }
    }
    '2' = @{
        class_type = 'CLIPLoader'
        inputs = @{
            clip_name = 'qwen_2.5_vl_7b_fp8_scaled.safetensors'
            type = 'qwen_image'
            device = 'default'
        }
    }
    '3' = @{
        class_type = 'VAELoader'
        inputs = @{ vae_name = 'qwen_image_vae.safetensors' }
    }
    '4' = @{
        class_type = 'ModelSamplingAuraFlow'
        inputs = @{
            model = @('1', 0)
            shift = 3.1
        }
    }
    '5' = @{
        class_type = 'CLIPTextEncode'
        inputs = @{
            clip = @('2', 0)
            text = $Prompt
        }
    }
    '6' = @{
        class_type = 'CLIPTextEncode'
        inputs = @{
            clip = @('2', 0)
            text = $negative
        }
    }
    '7' = @{
        class_type = 'EmptySD3LatentImage'
        inputs = @{
            width = $Width
            height = $Height
            batch_size = 1
        }
    }
    '8' = @{
        class_type = 'KSampler'
        inputs = @{
            model = @('4', 0)
            positive = @('5', 0)
            negative = @('6', 0)
            latent_image = @('7', 0)
            seed = $Seed
            steps = 50
            cfg = 4
            sampler_name = 'euler'
            scheduler = 'simple'
            denoise = 1
        }
    }
    '9' = @{
        class_type = 'VAEDecode'
        inputs = @{
            samples = @('8', 0)
            vae = @('3', 0)
        }
    }
    '10' = @{
        class_type = 'SaveImage'
        inputs = @{
            images = @('9', 0)
            filename_prefix = $FilenamePrefix
        }
    }
}

$body = @{ prompt = $graph } | ConvertTo-Json -Depth 12
$queued = Invoke-RestMethod -Uri "$Server/prompt" -Method Post -ContentType 'application/json' -Body $body
$promptId = $queued.prompt_id
if (-not $promptId) {
    throw "ComfyUI did not return a prompt_id: $($queued | ConvertTo-Json -Depth 5)"
}

if ($QueueOnly) {
    [pscustomobject]@{
        PromptId = $promptId
        Seed = $Seed
        Width = $Width
        Height = $Height
        FilenamePrefix = $FilenamePrefix
        IntendedOutput = $OutputPath
    }
    return
}

$deadline = (Get-Date).AddSeconds($TimeoutSeconds)
$history = $null
while ((Get-Date) -lt $deadline) {
    Start-Sleep -Seconds 2
    $historyResponse = Invoke-RestMethod -Uri "$Server/history/$promptId"
    $history = $historyResponse.PSObject.Properties[$promptId].Value
    if ($history) {
        break
    }
}

if (-not $history) {
    throw "Timed out waiting for ComfyUI prompt $promptId."
}

$statusText = $history.status.status_str
if ($statusText -and $statusText -ne 'success') {
    throw "ComfyUI prompt $promptId ended with status '$statusText'."
}

$saveOutput = $history.outputs.PSObject.Properties['10'].Value
$image = @($saveOutput.images)[0]
if (-not $image.filename) {
    throw "ComfyUI prompt $promptId completed without a saved image."
}

$comfyOutput = 'D:\comfyui\ComfyUI-Easy-Install\ComfyUI\output'
$sourcePath = if ($image.subfolder) {
    Join-Path (Join-Path $comfyOutput $image.subfolder) $image.filename
} else {
    Join-Path $comfyOutput $image.filename
}

$destinationDirectory = Split-Path -Parent $OutputPath
New-Item -ItemType Directory -Force -Path $destinationDirectory | Out-Null
Copy-Item -LiteralPath $sourcePath -Destination $OutputPath -Force

[pscustomobject]@{
    PromptId = $promptId
    Seed = $Seed
    Width = $Width
    Height = $Height
    Source = $sourcePath
    Output = (Resolve-Path -LiteralPath $OutputPath).Path
}
