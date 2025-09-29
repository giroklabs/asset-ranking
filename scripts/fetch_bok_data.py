#!/usr/bin/env python3
"""
한국은행 API에서 자산 데이터를 가져오는 스크립트
"""

import requests
import json
import datetime
from typing import Dict, Any

# 한국은행 API 설정
API_KEY = "5RTMINGVGFOXMT0UHGJS"
BASE_URL = "https://ecos.bok.or.kr/api"
STATISTIC_CODE = "020Y001"  # 가계부채 통계

def fetch_bok_data() -> Dict[str, Any]:
    """한국은행 API에서 데이터 가져오기"""
    
    # 날짜 범위 설정 (최근 1년)
    end_date = datetime.datetime.now()
    start_date = end_date - datetime.timedelta(days=365)
    
    start_str = start_date.strftime("%Y%m")
    end_str = end_date.strftime("%Y%m")
    
    url = f"{BASE_URL}/StatisticSearch/{API_KEY}/json/kr/1/100/{STATISTIC_CODE}/DD/{start_str}/{end_str}"
    
    print(f"🔄 한국은행 API 호출: {url}")
    
    try:
        response = requests.get(url, timeout=30)
        response.raise_for_status()
        
        data = response.json()
        print(f"✅ API 응답 성공: {data.get('StatisticSearch', {}).get('list_total_count', 0)}개 데이터")
        
        return data
        
    except requests.exceptions.RequestException as e:
        print(f"❌ API 호출 실패: {e}")
        return {}
    except json.JSONDecodeError as e:
        print(f"❌ JSON 파싱 실패: {e}")
        return {}

def process_monthly_data(bok_data: Dict[str, Any]) -> list:
    """월별 데이터 처리"""
    
    monthly_data = []
    
    if 'StatisticSearch' in bok_data and 'row' in bok_data['StatisticSearch']:
        rows = bok_data['StatisticSearch']['row']
        
        # 월별로 그룹화
        monthly_groups = {}
        for row in rows:
            time_str = row.get('TIME', '')
            if len(time_str) == 6:  # YYYYMM 형식
                month = time_str
                if month not in monthly_groups:
                    monthly_groups[month] = []
                monthly_groups[month].append(row)
        
        # 각 월별 데이터 처리
        for month, rows in monthly_groups.items():
            if rows:
                # 평균 부채 계산
                debt_values = []
                for row in rows:
                    try:
                        debt = float(row.get('DATA_VALUE', 0))
                        if debt > 0:
                            debt_values.append(debt)
                    except (ValueError, TypeError):
                        continue
                
                if debt_values:
                    avg_debt = int(sum(debt_values) / len(debt_values))
                    # 부채 대비 자산 비율 추정 (일반적으로 4:1)
                    avg_assets = avg_debt * 4
                    net_worth = avg_assets - avg_debt
                    debt_ratio = avg_debt / avg_assets if avg_assets > 0 else 0.25
                    
                    monthly_data.append({
                        "date": month,
                        "averageDebt": avg_debt,
                        "averageAssets": avg_assets,
                        "netWorth": net_worth,
                        "debtRatio": round(debt_ratio, 2)
                    })
    
    return monthly_data

if __name__ == "__main__":
    print("🚀 한국은행 데이터 수집 시작")
    
    # 데이터 가져오기
    bok_data = fetch_bok_data()
    
    if bok_data:
        # 월별 데이터 처리
        monthly_data = process_monthly_data(bok_data)
        
        # 결과 저장
        result = {
            "lastUpdated": datetime.datetime.now().strftime("%Y-%m-%d"),
            "dataSource": "한국은행 ECOS API",
            "version": "1.0.0",
            "monthlyData": monthly_data
        }
        
        with open('temp_bok_data.json', 'w', encoding='utf-8') as f:
            json.dump(result, f, ensure_ascii=False, indent=2)
        
        print(f"✅ 임시 데이터 저장 완료: {len(monthly_data)}개 월별 데이터")
    else:
        print("❌ 데이터 수집 실패")
