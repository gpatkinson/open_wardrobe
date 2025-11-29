"""
Background Removal Service using rembg
Removes backgrounds from clothing/item images
"""

from flask import Flask, request, send_file, jsonify
from flask_cors import CORS
from rembg import remove
from PIL import Image
import pillow_heif  # Add HEIC/HEIF support
import io
import logging

# Register HEIF/HEIC opener with Pillow
pillow_heif.register_heif_opener()

app = Flask(__name__)
CORS(app)  # Allow cross-origin requests from the Flutter app

logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

@app.route('/health', methods=['GET'])
def health():
    """Health check endpoint"""
    return jsonify({'status': 'healthy', 'service': 'rembg'})

@app.route('/remove-bg', methods=['POST'])
def remove_background():
    """
    Remove background from an uploaded image
    Expects: multipart/form-data with 'image' field
    Returns: PNG image with transparent background
    """
    try:
        if 'image' not in request.files:
            return jsonify({'error': 'No image provided'}), 400
        
        file = request.files['image']
        if file.filename == '':
            return jsonify({'error': 'No image selected'}), 400
        
        logger.info(f"Processing image: {file.filename}")
        
        # Read the input image
        input_image = Image.open(file.stream)
        
        # Convert to RGB if necessary (rembg works best with RGB)
        if input_image.mode in ('RGBA', 'LA', 'P'):
            # Keep alpha for processing
            input_image = input_image.convert('RGBA')
        else:
            input_image = input_image.convert('RGB')
        
        # Remove background
        output_image = remove(input_image)
        
        # Save to bytes
        img_byte_arr = io.BytesIO()
        output_image.save(img_byte_arr, format='PNG', optimize=True)
        img_byte_arr.seek(0)
        
        logger.info(f"Successfully processed: {file.filename}")
        
        return send_file(
            img_byte_arr,
            mimetype='image/png',
            as_attachment=True,
            download_name='processed.png'
        )
        
    except Exception as e:
        logger.error(f"Error processing image: {str(e)}")
        return jsonify({'error': str(e)}), 500

@app.route('/', methods=['GET'])
def index():
    """Root endpoint with usage info"""
    return jsonify({
        'service': 'Background Removal Service',
        'version': '1.0',
        'endpoints': {
            '/health': 'GET - Health check',
            '/remove-bg': 'POST - Remove background (multipart/form-data with "image" field)'
        }
    })

if __name__ == '__main__':
    # Pre-load the model on startup
    logger.info("Pre-loading rembg model...")
    try:
        # Create a small test image to trigger model download
        test_img = Image.new('RGB', (10, 10), color='white')
        remove(test_img)
        logger.info("Model loaded successfully!")
    except Exception as e:
        logger.warning(f"Model pre-load warning: {e}")
    
    app.run(host='0.0.0.0', port=5000, debug=False)

