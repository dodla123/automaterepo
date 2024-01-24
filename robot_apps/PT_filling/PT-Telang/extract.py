import cv2
import pytesseract

def extract_text_from_image_file(image_path, output_file_path):

    img = cv2.imread(image_path)
    if img is not None:
        
        # Use Tesseract to extract text
        text = pytesseract.image_to_string(img, config='--psm 6 -l eng')
        # print(text)
        # text = 'hiiiiiii'
       
        # Write the extracted text to a file
        try:
            with open(output_file_path, 'w', encoding='utf-8') as output_file:
                output_file.write(text)
            print(f"Text extracted successfully and saved to {output_file_path}")
        except Exception as e:
            print(f"Error: Unable to write text to file {output_file_path}. Error: {e}")
    else:
        # Print an error message if the image could not be read
        print(f"Error: Unable to read image from {image_path}")
        

# Example usage with a local file path
image_path = "/home/buzzadmin/Documents/ESIC_BOT/login/robot_apps/PT_filling/PT-Telang/screenshotT.png"
output_file_path = "/home/buzzadmin/Documents/ESIC_BOT/login/robot_apps/PT_filling/PT-Telang/extracted_text.txt"

extract_text_from_image_file(image_path, output_file_path)


