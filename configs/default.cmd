@echo off
:: EFI ���
set efiDriver=H:
:: Windows ���
set imageDriver=G:
:: wim Image ·��
set wimPath=.\wim\win11-2024-10.wim
::ѡ��װϵͳ�汾����
set wimIndex=5
:: ��������Ŀ¼
set importDriverPath=.\driver\����
:: ����ֵ��Ӧ��·��
set unattendPath=.\Panther\unattend.xml
:: Microsoft.UI.Xaml ·��
set MicrosoftUIXamlPath=.\appx\Microsoft.UI.Xaml.2.8.x64.appx
::�Ƿ��ʽ��(0:����ʽ�� 1:��ʽ��)
set format=1
::�Ƿ�װ���� (0:����װ 1:��װ)
set installImage=1
::�Ƿ���������ļ� (0:���ؽ� 1:�ؽ�)
set rebuildEFI=1
::�����ļ������Ƿ񱣴�ԭ��ϵͳ���� (0:������ 1:������
set otherBOOT=0
:: ��ɺ����� (0:������ 1:����)
set reboot=1
::�Ƿ��������  (0:����� 1:���) 
set addDriver=1
::�Ƿ��������ֵ�� (0:����� 1:���) 
set addAttend=1
::�Ƿ�װ Microsoft.UI.Xaml.2.8 apx (0:����װ 1:��װ) 
set addMicrosoftUIXaml=1